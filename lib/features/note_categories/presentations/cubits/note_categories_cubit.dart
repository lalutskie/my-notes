import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart' show Hive;
import 'package:hive_firebase/features/note_categories/domain/model/note_categories_model.dart';
import 'package:hive_firebase/features/note_categories/domain/repos/note_categories_repo.dart';
import 'package:hive_firebase/features/sync_settings/sync_data_source.dart';

import 'note_categories_state.dart';

class NoteCategoriesCubit extends Cubit<NoteCategoriesState> {
  final NoteCategoriesRepo noteCategoriesRepo;
  final SyncDataSource syncDataSource;
  final noteCategoriesBox = Hive.box<NoteCategoriesModel>('noteCategories');

  NoteCategoriesCubit(this.syncDataSource, {required this.noteCategoriesRepo})
    : super(NoteCategoriesInitial());

  Future<void> createNoteCategory(
    NoteCategoriesModel noteCategoriesModel,
  ) async {
    emit(NoteCategoriesUploading());
    try {
      // Check if sync was on
      final sync = syncDataSource.getCurrentSync();
      if (sync.isSyncEnabled) {
        await noteCategoriesRepo.createCategories(noteCategoriesModel);
      }

      // Always adding locally
      await noteCategoriesBox.put(noteCategoriesModel.id, noteCategoriesModel);

      // Getting the new categories and update it after sorting
      final noteCategories = noteCategoriesBox.values.toList();
      _sortNoteCategories(noteCategories);
      emit(NoteCategoriesLoaded(noteCategories));
    } catch (e) {
      emit(NoteCategoriesError(e.toString()));
    }
  }

  Future<void> updateNoteCategory(
    NoteCategoriesModel noteCategoriesModel,
  ) async {
    // ✅ Save the current notes BEFORE changing state
    final previousCategory = (state is NoteCategoriesLoaded)
        ? List<NoteCategoriesModel>.from(
            (state as NoteCategoriesLoaded).noteCategoriesModel,
          )
        : null;

    emit(NoteCategoriesLoading());
    try {
      final sync = syncDataSource.getCurrentSync();

      if (sync.isSyncEnabled) {
        await noteCategoriesRepo.updateCategory(noteCategoriesModel);
      }

      await noteCategoriesBox.put(noteCategoriesModel.id, noteCategoriesModel);
      List<NoteCategoriesModel> currentCategories;

      if (previousCategory != null) {
        currentCategories = previousCategory;
        final index = currentCategories.indexWhere(
          (n) => n.id == noteCategoriesModel.id,
        );

        if (index != -1) {
          currentCategories[index] = noteCategoriesModel;
        }
      } else {
        currentCategories = noteCategoriesBox.values.toList();
      }

      _sortNoteCategories(currentCategories);
      emit(NoteCategoriesLoaded(currentCategories));
    } catch (e) {
      emit(NoteCategoriesError(e.toString()));
    }
  }

  Future<void> getNoteCategories(String userId) async {
    emit(NoteCategoriesLoading());
    try {
      final sync = syncDataSource.getCurrentSync();
      List<NoteCategoriesModel> mergedCategories;
      if (sync.isSyncEnabled) {
        mergedCategories = await _mergeAndSync(userId);
      } else {
        mergedCategories = noteCategoriesBox.values.toList();
      }

      _sortNoteCategories(mergedCategories);
      emit(NoteCategoriesLoaded(mergedCategories));
    } catch (e) {
      emit(NoteCategoriesError(e.toString()));
    }
  }

  Future<void> deleteNoteCategory(String categoryId) async {
  emit(NoteCategoriesLoading());
  try {
    final sync = syncDataSource.getCurrentSync();
    
    if (sync.isSyncEnabled) {
      // Sync is ON: Hard delete from both local and remote
      await noteCategoriesRepo.deleteCategory(categoryId);
      await noteCategoriesBox.delete(categoryId);
    } else {
      // Sync is OFF: Soft delete (mark as deleted for later sync)
      final categoryToDelete = noteCategoriesBox.get(categoryId);
      
      if (categoryToDelete != null) {
        final deletedCategory = categoryToDelete.copyWith(
          isDeleted: true,
          deletedAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        await noteCategoriesBox.put(categoryId, deletedCategory);
      }
    }

    // Get updated list (excluding soft-deleted items)
    final updatedCategories = noteCategoriesBox.values
        .where((category) => !category.isDeleted)
        .toList();
    
    _sortNoteCategories(updatedCategories);
    emit(NoteCategoriesLoaded(updatedCategories));
  } catch (e) {
    emit(NoteCategoriesError(e.toString()));
  }
}

  Future<List<NoteCategoriesModel>> _mergeAndSync(String uid) async {
  // 1️⃣ Fetch data
  final localNoteCategories = noteCategoriesBox.values.toList();
  final remoteNoteCategories = await noteCategoriesRepo.getNoteCategories(uid);

  // 2️⃣ Index by ID for fast lookup
  final localMap = {for (var c in localNoteCategories) c.id: c};
  final remoteMap = {for (var c in remoteNoteCategories) c.id: c};
  final allIds = {...localMap.keys, ...remoteMap.keys};

  // 3️⃣ Prepare structures
  final List<NoteCategoriesModel> merged = [];
  final Map<String, NoteCategoriesModel> hiveUpdates = {};
  final List<NoteCategoriesModel> firestoreToCreateOrUpdate = [];
  final List<String> firestoreToDelete = [];
  final List<String> hiveToDelete = []; // NEW: Track items to hard delete from Hive

  // 4️⃣ Merge logic
  for (final id in allIds) {
    final local = localMap[id];
    final remote = remoteMap[id];

    // Case 1: Remote-only → save locally
    if (local == null && remote != null) {
      hiveUpdates[remote.id] = remote;
      if (!remote.isDeleted) merged.add(remote);
      continue;
    }

    // Case 2: Local-only
    if (local != null && remote == null) {
      if (local.isDeleted) {
        // Local was soft-deleted while offline, now hard delete it
        hiveToDelete.add(local.id);
        // No need to delete from remote (it doesn't exist there)
      } else {
        // Local exists and not deleted, push to remote
        firestoreToCreateOrUpdate.add(local);
        merged.add(local);
      }
      continue;
    }

    // Case 3: Both exist → resolve conflict by timestamp
    if (local != null && remote != null) {
      final localUpdated = local.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final remoteUpdated = remote.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

      // Local is newer
      if (localUpdated.isAfter(remoteUpdated)) {
        if (local.isDeleted) {
          // Local deleted while offline, delete from remote and local
          firestoreToDelete.add(local.id);
          hiveToDelete.add(local.id);
        } else {
          // Local updated more recently, push to remote
          firestoreToCreateOrUpdate.add(local);
          hiveUpdates[local.id] = local;
          merged.add(local);
        }
      } 
      // Remote is newer or equal
      else {
        if (remote.isDeleted) {
          // Remote was deleted, hard delete from local too
          hiveToDelete.add(remote.id);
        } else {
          // Remote is newer and not deleted, use remote version
          hiveUpdates[remote.id] = remote;
          merged.add(remote);
        }
      }
    }
  }

  // 5️⃣ Batch Hive updates
  if (hiveUpdates.isNotEmpty) {
    await noteCategoriesBox.putAll(hiveUpdates);
  }

  // 6️⃣ Hard delete from Hive
  if (hiveToDelete.isNotEmpty) {
    await noteCategoriesBox.deleteAll(hiveToDelete);
  }

  // 7️⃣ Batch Firestore operations
  if (firestoreToCreateOrUpdate.isNotEmpty || firestoreToDelete.isNotEmpty) {
    final batch = FirebaseFirestore.instance.batch();
    final collection = FirebaseFirestore.instance.collection('note_categories');

    // Create or update
    for (final category in firestoreToCreateOrUpdate) {
      final docRef = collection.doc(category.id);
      batch.set(docRef, category.toMap(), SetOptions(merge: true));
    }

    // Delete from Firestore
    for (final id in firestoreToDelete) {
      final docRef = collection.doc(id);
      batch.delete(docRef);
    }

    await batch.commit();
  }

  // 8️⃣ Sort before returning
  _sortNoteCategories(merged);

  return merged;
}

  Future<void> enableSyncAndMerge(String uid) async {
    emit(NoteCategoriesLoading());
    try {
      final noteCategories = await _mergeAndSync(uid);
      _sortNoteCategories(noteCategories);
      emit(NoteCategoriesLoaded(noteCategories));
    } catch (e) {
      emit(NoteCategoriesError(e.toString()));
    }
  }

  void _sortNoteCategories(List<NoteCategoriesModel> categories) {
    categories.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
  }
}

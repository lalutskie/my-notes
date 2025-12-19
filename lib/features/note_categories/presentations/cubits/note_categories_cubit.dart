
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart' show Hive;
import 'package:hive_firebase/features/note_categories/domain/model/note_categories_model.dart';
import 'package:hive_firebase/features/note_categories/domain/repos/note_categories_repo.dart';
import 'package:hive_firebase/features/sync_settings/sync_data_source.dart';

import 'note_categories_state.dart';

class NoteCategoriesCubit extends Cubit<NoteCategoriesState>{
  final NoteCategoriesRepo noteCategoriesRepo;
  final SyncDataSource syncDataSource;
  final noteCategoriesBox = Hive.box<NoteCategoriesModel>('noteCategories');

  NoteCategoriesCubit(this.syncDataSource, {required this.noteCategoriesRepo}) : super(NoteCategoriesInitial());

  Future<void> createNoteCategory(NoteCategoriesModel noteCategoriesModel) async {
    emit(NoteCategoriesUploading());
    try {

      // Check if sync was on
      final sync = syncDataSource.getCurrentSync();
      if(sync.isSyncEnabled) {
        await noteCategoriesRepo.createCategories(noteCategoriesModel);
      }

      // Always adding locally
      await noteCategoriesBox.put(noteCategoriesModel.id, noteCategoriesModel);

      // Getting the new categories and update it after sorting
      final noteCategories = noteCategoriesBox.values.toList();
      _sortNoteCategories(noteCategories);
      emit(NoteCategoriesLoaded(noteCategories));
      
    } catch(e) {
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

  Future<void> deleteNoteCategory(String categoryId) async{ 
    emit(NoteCategoriesLoading());
    try {

      final sync = syncDataSource.getCurrentSync();
      if(sync.isSyncEnabled) {
        await noteCategoriesRepo.deleteCategory(categoryId);
      }

      await noteCategoriesBox.delete(categoryId);

      final updatedCategories = noteCategoriesBox.values.toList();
      _sortNoteCategories(updatedCategories);
      emit(NoteCategoriesLoaded(updatedCategories));
    } catch(e) {
      emit(NoteCategoriesError(e.toString()));
    }
  }

  Future<void> getNoteCategories(String userId) async{
    emit(NoteCategoriesLoading());
    try {
      final sync = syncDataSource.getCurrentSync();
      List<NoteCategoriesModel> mergedCategories;
      if(sync.isSyncEnabled) {
        mergedCategories = await _mergeAndSync(userId);
      } else {
        mergedCategories = noteCategoriesBox.values.toList();
      }

      _sortNoteCategories(mergedCategories);
      emit(NoteCategoriesLoaded(mergedCategories));
    } catch(e) {
      emit(NoteCategoriesError(e.toString()));
    }
  }

  Future<List<NoteCategoriesModel>> _mergeAndSync(String uid) async {
    // 1️⃣ Fetch data
    final localNoteCategories = noteCategoriesBox.values.toList();
    final remoteNoteCategories = await noteCategoriesRepo.getNoteCategories(
      uid,
    );

    // 2️⃣ Index by ID for fast lookup
    final localMap = {for (var c in localNoteCategories) c.id: c};
    final remoteMap = {for (var c in remoteNoteCategories) c.id: c};
    final allIds = {...localMap.keys, ...remoteMap.keys};

    // 3️⃣ Prepare structures
    final List<NoteCategoriesModel> merged = [];
    final Map<String, NoteCategoriesModel> hiveUpdates = {};
    final List<NoteCategoriesModel> firestoreToCreateOrUpdate = [];
    final List<String> firestoreToDelete = [];

    // 4️⃣ Merge logic
    for (final id in allIds) {
      final local = localMap[id];
      final remote = remoteMap[id];

      // Remote-only → save locally
      if (local == null && remote != null) {
        hiveUpdates[remote.id] = remote;
        if (!remote.isDeleted) merged.add(remote);
        continue;
      }

      // Local-only → push to Firebase
      if (local != null && remote == null) {
        if (local.isDeleted) {
          firestoreToDelete.add(local.id);
        } else {
          firestoreToCreateOrUpdate.add(local);
          merged.add(local);
        }
        continue;
      }

      // Both exist → resolve conflict
      if (local != null && remote != null) {
        final localUpdated =
            local.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final remoteUpdated =
            remote.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

        if (localUpdated.isAfter(remoteUpdated)) {
          firestoreToCreateOrUpdate.add(local);
          hiveUpdates[local.id] = local;
          if (!local.isDeleted) merged.add(local);
        } else {
          hiveUpdates[remote.id] = remote;
          if (!remote.isDeleted) merged.add(remote);
        }
      }
    }

    // 5️⃣ Batch Hive update
    if (hiveUpdates.isNotEmpty) {
      await noteCategoriesBox.putAll(hiveUpdates);
    }

    // 6️⃣ Batch Firestore operations
    if (firestoreToCreateOrUpdate.isNotEmpty || firestoreToDelete.isNotEmpty) {
      final batch = FirebaseFirestore.instance.batch();
      final collection = FirebaseFirestore.instance.collection(
        'note_categories',
      );

      // Create or update
      for (final category in firestoreToCreateOrUpdate) {
        final docRef = collection.doc(category.id);
        batch.set(docRef, category.toMap(), SetOptions(merge: true));
      }

      // Delete
      for (final id in firestoreToDelete) {
        final docRef = collection.doc(id);
        batch.update(docRef, {'isDeleted': true, 'deletedAt': DateTime.now()});
      }

      await batch.commit();
    }

    // 7️⃣ Sort before returning (optional)
    _sortNoteCategories(merged);

    return merged;
  }

  

  void _sortNoteCategories(List<NoteCategoriesModel> categories) {
    categories.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_firebase/features/note_categories/domain/model/note_categories_model.dart';
import 'package:hive_firebase/features/note_categories/domain/repos/note_categories_repo.dart';

class FirebaseNoteCategoriesRepo implements NoteCategoriesRepo {

  final FirebaseFirestore _fStore = FirebaseFirestore.instance;
  final String collectionPath = 'note_categories';

  @override
  Future<void> createCategories(NoteCategoriesModel noteCategoriesModel) async {
    try{
      await _fStore.collection(collectionPath)
      .doc(noteCategoriesModel.id)
      .set(noteCategoriesModel.toMap());
    } catch(e) {
      throw Exception('Error creating note category: $e');
    }
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _fStore.collection(collectionPath)
      .doc(categoryId)
      .delete();
    } catch (e) {
      throw Exception('Error deleting note category: $e');
    }
  }

  @override
  Future<List<NoteCategoriesModel>> getNoteCategories(String userId) async {
    try {
      final noteCategorySnapshot = await _fStore.collection(collectionPath).where('uid', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .get();

      final remoteNotes = noteCategorySnapshot.docs.map((doc) => NoteCategoriesModel.fromMap({...doc.data(), 'id': doc.id})).toList();
    
      return remoteNotes;
    } catch(e) {
      throw Exception('Error getting categories notes: $e');
    }
  }

  @override
  Future<void> updateCategory(NoteCategoriesModel noteCategoriesModel) async {
    try {
      final updateCategory = NoteCategoriesModel(
        id: noteCategoriesModel.id, 
        uid: noteCategoriesModel.uid, 
        name: noteCategoriesModel.name,
        updatedAt: DateTime.now
        (),);

        await _fStore.collection(collectionPath)
        .doc(updateCategory.id)
        .update(updateCategory.toMap());
    } catch (e) {
      throw Exception('Error updating category: $e');
    }
  }


}
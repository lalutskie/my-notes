
import 'package:hive_firebase/features/note_categories/domain/model/note_categories_model.dart';

abstract class NoteCategoriesRepo {
  Future<void> createCategories(NoteCategoriesModel noteCategoriesModel);

  Future<void> updateCategory(NoteCategoriesModel noteCategoriesModel);

  Future<void> deleteCategory(String categoryId);

  Future<List<NoteCategoriesModel>> getNoteCategories(String userId);
}
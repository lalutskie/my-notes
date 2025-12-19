
import 'package:hive_firebase/features/note_categories/domain/model/note_categories_model.dart';

abstract class NoteCategoriesState {}

class NoteCategoriesInitial extends NoteCategoriesState {}

class NoteCategoriesLoading extends NoteCategoriesState {}

class NoteCategoriesUploading extends NoteCategoriesState {}

class NoteCategoriesLoaded extends NoteCategoriesState {
  final List<NoteCategoriesModel> noteCategoriesModel;
  NoteCategoriesLoaded(this.noteCategoriesModel);
}

class NoteCategoriesError extends NoteCategoriesState {
  final String errorMessage;
  NoteCategoriesError(this.errorMessage);
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_firebase/components/custom_back_button.dart';
import 'package:hive_firebase/components/custom_button.dart';
import 'package:hive_firebase/components/custom_loading.dart';
import 'package:hive_firebase/components/custom_snackbar_service.dart';
import 'package:hive_firebase/components/custom_textfield.dart';
import 'package:hive_firebase/features/authentication/domain/models/user_model.dart';
import 'package:hive_firebase/features/authentication/presentations/cubits/auth_cubit.dart';
import 'package:hive_firebase/features/note_categories/domain/model/note_categories_model.dart';
import 'package:hive_firebase/features/note_categories/presentations/cubits/note_categories_cubit.dart';
import 'package:hive_firebase/features/note_categories/presentations/cubits/note_categories_state.dart';

import '../utils/custom_theme.dart';

class CreateNoteCategoryPage extends StatefulWidget {
  const CreateNoteCategoryPage({super.key});

  @override
  State<CreateNoteCategoryPage> createState() => _CreateNoteCategoryPageState();
}

class _CreateNoteCategoryPageState extends State<CreateNoteCategoryPage> {

  final TextEditingController _categoryController = TextEditingController();

  late final authCubit = context.read<AuthCubit>();
  late final noteCategoryCubit = context.read<NoteCategoriesCubit>();
  late UserModel? user;

  @override
  void initState() {
    user = authCubit.currentUser;
    super.initState();
  }

  void createNoteCategory() async {
    if(user == null) {
      return CustomSnackbarService.showError(context, 'No user found to create');
    }

    if(_categoryController.text.isEmpty) {
      return;
    }

    await noteCategoryCubit.createNoteCategory(
      NoteCategoriesModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(), 
        uid: user!.uid, 
        name: _categoryController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),)
    );
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: 
      SizedBox(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          child: Column(
            children: [
              Row(
                spacing: 5,
                children: [
                  CustomBackButton(function: () => context.pop(),),

                  Text(
                      'Create new label',
                      style: CustomTheme.typography(context).headlineSmall
                          .copyWith(
                            color: CustomTheme.colors(context).primaryText,
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    
                ],
              ),

              SizedBox(height: 16,),

              CustomTextfield(
                  minLines: 3,
                  maxLines: 5,
                  hintText: 'Type here...',
                  controller: _categoryController,
                  obSecureText: false,
              ),

              Spacer(),

              BlocConsumer<NoteCategoriesCubit, NoteCategoriesState>(
                builder: (context, state) {
                  if(state is NoteCategoriesUploading) {
                    return CustomLoading();
                  }

                  return CustomButton(
                      text: 'Add label',
                      function: () => createNoteCategory(),
                      width: double.infinity,
                    );

                }, listener: (context, state) {
                  if(state is NoteCategoriesError) {
                    return CustomSnackbarService.showSuccess(context, state.errorMessage);
                  }

                  if(state is NoteCategoriesLoaded) {
                    return context.pop();
                  }
                })

              
            ],
          ),
        ),
      )),
    );
  }
}
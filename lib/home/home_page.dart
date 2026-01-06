import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_firebase/components/custom_floating_button.dart';
import 'package:hive_firebase/components/custom_loading.dart';
import 'package:hive_firebase/components/custom_nav_bar.dart';
import 'package:hive_firebase/components/notes_category_list.dart';
import 'package:hive_firebase/components/notes_list.dart';
import 'package:hive_firebase/components/pop_up_menu.dart';
import 'package:hive_firebase/features/note_categories/presentations/cubits/note_categories_cubit.dart';
import 'package:hive_firebase/features/note_categories/presentations/cubits/note_categories_state.dart';
import 'package:hive_firebase/features/notes/presentations/cubits/notes_cubit.dart';
import 'package:hive_firebase/features/notes/presentations/cubits/notes_state.dart';

import '../features/authentication/domain/models/user_model.dart';
import '../features/authentication/presentations/cubits/auth_cubit.dart';
import '../utils/custom_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final authCubit = context.read<AuthCubit>();
  late final notesCubit = context.read<NotesCubit>();
  late final noteCategoriesCubit = context.read<NoteCategoriesCubit>();
  late final UserModel? user;

  String? currentLabelId;

  @override
  void initState() {
    if (authCubit.currentUser != null) {
      user = authCubit.currentUser;
      notesCubit.getNoteList(user!.uid);
      noteCategoriesCubit.getNoteCategories(user!.uid);
    
    }
    super.initState();
  }

  void _selectLabelId(String? id) {
    setState(() {
      currentLabelId = id;
    });
    notesCubit.filterByLabel(currentLabelId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingButton(onTap: () => context.push('/create-note')),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Home',
                      style: CustomTheme.typography(context).headlineSmall
                          .copyWith(
                            color: CustomTheme.colors(context).primaryText,
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    PopUpMenu(),
                    
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 00, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "There's something on your mind? Right it down",
                        style: CustomTheme.typography(context).bodyMedium
                            .copyWith(
                              color: CustomTheme.colors(context).tertiaryText,
                            ),
                      ),

                      const SizedBox(height: 8),

                      BlocBuilder<NoteCategoriesCubit, NoteCategoriesState>(
                        builder: (context, state) {
                          if(state is NoteCategoriesLoaded){
                            if(state.noteCategoriesModel.isEmpty) {
                              return GestureDetector(
                                onTap: () =>
                                    context.push('/create-note-category'),
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    8,
                                    5,
                                    8,
                                    5,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    border: BoxBorder.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text('+ Create label'),
                                ),
                              );
                            }

                            return NotesCategoryList(noteCategoriesList: state.noteCategoriesModel, onSelected: _selectLabelId, currentSelectedId: currentLabelId,);
                            
                          }

                          return CustomLoading();
                        },
                      ),


                      SizedBox(height: 16),

                      BlocBuilder<NotesCubit, NotesState>(
                        builder: (context, state) {
                          if (state is NotesLoaded) {
                            return Expanded(
                              child: NotesList(
                                notes: state.notesModel,
                                emptyMessage:
                                    "Notes are empty. Try to create one!",
                                isListArchived: false,
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: CustomLoading(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              CustomNavBar(currentPage: 'home'),
            ],
          ),
        ),
      ),
    );
  }
}

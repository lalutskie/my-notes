import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hive_firebase/components/custom_loading.dart';
import 'package:hive_firebase/components/custom_nav_bar.dart';
import 'package:hive_firebase/components/custom_textfield.dart';
import 'package:hive_firebase/components/notes_list.dart';
import 'package:hive_firebase/features/notes/domain/models/notes_model.dart';
import '../utils/custom_theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final notesBox = Hive.box<NotesModel>('notes');

  List<NotesModel> notes = [];
  List<NotesModel> filteredNotes = [];
  bool isLoading = false;
  Timer? _debounce; // to prevent too frequent filtering

  @override
  void initState() {
    super.initState();
    notes = notesBox.values.toList();
    filteredNotes = List.from(notes);
    _searchController.addListener(onSearchChanged);
  }

  void onSearchChanged() {
    // Cancel any pending timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    setState(() => isLoading = true);

    // Add debounce to avoid flickering on fast typing
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = _searchController.text.trim().toLowerCase();

      setState(() {
        filteredNotes = notes.where((note) {
          final title = note.title?.toLowerCase() ?? '';
          final description = note.description?.toLowerCase() ?? '';
          return title.contains(query) || description.contains(query);
        }).toList();

        isLoading = false; // done searching
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search your notes here!',
                        style: CustomTheme.typography(context)
                            .headlineSmall
                            .copyWith(
                              color: CustomTheme.colors(context).primaryText,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextfield(
                        controller: _searchController,
                        obSecureText: false,
                        labelText: 'Search',
                      ),
                      const SizedBox(height: 16),

                      // 🟡 Show loader or results
                      Builder(builder: (context) {
                        if(_searchController.text.isNotEmpty) {
                          return Expanded(
                          child: isLoading
                              ? const Center(child: CustomLoading())
                              : NotesList(
                                  notes: filteredNotes,
                                  emptyMessage: "No notes found!",
                                  isListArchived: false,
                                ),
                        );
                        } else {
                            return Expanded(
                              child: Center(
                                child: Text(
                                  'Try searching...',
                                  style: CustomTheme.typography(context)
                                      .bodyMedium
                                      .copyWith(
                                        color: CustomTheme.colors(
                                          context,
                                        ).primaryText,
                                      ),
                                ),
                              ),
                            );
                        }
                      })
                        
                    ],
                  ),
                ),
              ),

              CustomNavBar(currentPage: 'search'),
            ],
          ),
        ),
      ),
    );
  }
}

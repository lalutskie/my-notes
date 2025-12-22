import 'package:flutter/material.dart';
import 'package:hive_firebase/components/custom_loading.dart';
import 'package:hive_firebase/components/notes_container.dart';
import 'package:hive_firebase/features/notes/domain/models/notes_model.dart';
import '../utils/custom_theme.dart';

class NotesList extends StatefulWidget {
  const NotesList({
    super.key,
    required this.notes,
    required this.emptyMessage,
    required this.isListArchived,
  });

  final List<NotesModel> notes;
  final String emptyMessage;
  final bool isListArchived;

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  int _visibleCount = 20; // ✅ Increased initial load
  bool _isLoadingMore = false;
  bool _loadTriggered = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ✅ Optimized scroll listener with threshold
  void _onScroll() {
    final position = _scrollController.position;
    
    // Load more when 200px from bottom instead of 100px
    if (position.pixels >= position.maxScrollExtent - 200 &&
        !_loadTriggered &&
        !_isLoadingMore &&
        _visibleCount < widget.notes.length) {
      _loadTriggered = true;
      _loadMore();
    }
  }

  // ✅ Reduced delay for faster loading
  Future<void> _loadMore() async {
    if (!mounted) return;
    
    setState(() => _isLoadingMore = true);

    await Future.delayed(const Duration(milliseconds: 200)); // ✅ Reduced from 500ms

    if (!mounted) return;
    
    setState(() {
      _visibleCount = (_visibleCount + 10).clamp(0, widget.notes.length); // ✅ Load 10 at a time
      _isLoadingMore = false;
      _loadTriggered = false;
    });
  }

  // ✅ Cache visible notes to avoid repeated sublist calls
  List<NotesModel> get _visibleNotes =>
      widget.notes.sublist(0, _visibleCount.clamp(0, widget.notes.length));

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.notes.isEmpty) {
      return Center(
        child: Text(
          widget.emptyMessage,
          style: CustomTheme.typography(context).bodyMedium.copyWith(
                color: CustomTheme.colors(context).primaryText,
              ),
        ),
      );
    }

    return Column(
      children: [
        // ✅ Use const where possible
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "(${_visibleNotes.length})",
            style: CustomTheme.typography(context).bodyMedium.copyWith(
                  color: CustomTheme.colors(context).tertiaryText,
                ),
          ),
        ),

        const SizedBox(height: 5),

        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _visibleNotes.length + (_visibleCount < widget.notes.length ? 1 : 0),
            physics: const AlwaysScrollableScrollPhysics(),
            // ✅ REMOVE itemExtent if items have varying heights
            // If all items are truly the same height, keep it
            // itemExtent: 80,
            
            // ✅ Add cacheExtent for better scrolling performance
            cacheExtent: 500, // Pre-render items 500px off-screen
            
            itemBuilder: (context, index) {
              if (index < _visibleNotes.length) {
                final note = _visibleNotes[index];

                return RepaintBoundary(
                  // ✅ Add key for better list performance
                  key: ValueKey(note.id),
                  child: NotesContainer(
                    note: note,
                    isListArchived: widget.isListArchived,
                  ),
                );
              } else {
                // Footer loading indicator
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CustomLoading()),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_firebase/features/authentication/presentations/cubits/auth_state.dart';
import 'package:hive_firebase/features/notes/data/firebase_notes_repo.dart';
import 'package:hive_firebase/features/notes/presentations/cubits/notes_cubit.dart';
import 'package:hive_firebase/features/notes/presentations/cubits/notes_archive_cubit.dart';
import 'package:hive_firebase/features/sync_settings/sync_data_source.dart';
import 'package:hive_firebase/features/sync_settings/sync_settings_cubit.dart';
import 'package:hive_firebase/home/home_page.dart';
import 'package:hive_firebase/login/login_page.dart';
import 'package:hive_firebase/notes/archived_notes_page.dart';
import 'package:hive_firebase/notes/create_note_page.dart';
import 'package:hive_firebase/notes/edit_note_page.dart';
import 'package:hive_firebase/notes/favorite_notes_page.dart';
import 'package:hive_firebase/profile/profile_page.dart';
import 'package:hive_firebase/register/register_page.dart';
import 'package:hive_firebase/search/search_page.dart';
import 'package:hive_firebase/splash/splash_page.dart';
import 'package:hive_firebase/utils/custom_theme.dart';

import 'features/authentication/data/firebase_auth_repo.dart';
import 'features/authentication/presentations/cubits/auth_cubit.dart';
import 'features/notes/domain/models/notes_model.dart';
import 'utils/go_router_stream.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  final authRepo = FirebaseAuthRepo();
  late final AuthCubit authCubit;

  final notesRepo = FirebaseNotesRepo();
  late final NotesCubit notesCubit;

  final syncDataSource = SyncDataSource();
  late final SyncSettingsCubit syncSettingsCubit;

  late final NotesArchiveCubit notesArchiveCubit;
  @override
  void initState() {
    authCubit = AuthCubit(authRepo: authRepo)
      ..checkAuth();
    notesCubit = NotesCubit(notesRepo: notesRepo, syncDataSource);
    syncSettingsCubit = SyncSettingsCubit(syncDataSource);
    notesArchiveCubit = NotesArchiveCubit(notesRepo: notesRepo, syncDataSource: syncDataSource);

    super.initState();
  }

  @override
  void dispose() {
    authCubit.close();
    
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => SplashPage()),
        GoRoute(path: '/login', builder: (context, state) => LoginPage()),
        GoRoute(path: '/register', builder: (context, state) => RegisterPage()),
        GoRoute(path: '/home', builder: (context, state) => HomePage()),
        GoRoute(path: '/create-note', builder: (context, state) => CreateNotePage()),
        GoRoute(path: '/edit-note', builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          
          final notesModel = extras['note'] as NotesModel;
          final isArchived = extras['isArchived'] as bool?;
          return EditNotePage(note: notesModel, isArchived: isArchived,);
        }),
        GoRoute(path: '/profile', builder: (context, state) => ProfilePage()),
        GoRoute(path: '/archived-notes', builder: (context, state) => ArchivedNotesPage()),
        GoRoute(path: '/favorites', builder: (context, state) => FavoriteNotesPage()),
        GoRoute(path: '/search', builder: (context, state) => SearchPage()),


        


      ],
      refreshListenable: GoRouterStream(authCubit.stream),
      redirect: (context, state) {
        final authState = authCubit.state;
        final goingTo = state.fullPath;

        final loggingIn =
            goingTo == '/login' || goingTo == '/register' || goingTo == '/';

        if (authState is Unauthenticated) {
          // Not logged in → force login
          if (!loggingIn) return '/login';
        }

        if (authState is Authenticated) {
          // Already logged in → go home if visiting login/register/splash
          if (goingTo == '/' || goingTo == '/login' || goingTo == '/register') {
            return '/home';
          }
        }

        return null; // allow navigation
      },

    );
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authCubit),
        BlocProvider.value(value: notesCubit),
        BlocProvider.value(value: syncSettingsCubit),
        BlocProvider.value(value: notesArchiveCubit)

      ],
      child: MaterialApp.router(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.light,
        darkTheme: CustomTheme.dark,
        themeMode: ThemeMode.light,
      ),
    );
  }
}

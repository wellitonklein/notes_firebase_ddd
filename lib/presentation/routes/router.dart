import 'package:auto_route/annotations.dart';

import '../notes/notes.dart';
import '../sign_in/sign_in.dart';
import '../splash/splash.dart';

@MaterialAutoRouter(
  generateNavigationHelperExtension: true,
  routes: <MaterialRoute>[
    MaterialRoute(page: SplashPage, initial: true),
    MaterialRoute(page: SignInPage),
    MaterialRoute(page: NotesOverviewPage),
    MaterialRoute(page: NoteFormPage, fullscreenDialog: true),
  ],
)
class $AppRouter {}

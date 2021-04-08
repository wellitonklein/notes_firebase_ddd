import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/application.dart';
import '../routes/router.gr.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.map(
          initial: (_) {},
          authenticated: (_) {
            AutoRouter.of(context).replace(const NotesOverviewPageRoute());
          },
          unauthenticated: (_) {
            Future.delayed(const Duration(seconds: 3), () {
              AutoRouter.of(context).replace(const SignInPageRoute());
            });
          },
        );
      },
      child: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

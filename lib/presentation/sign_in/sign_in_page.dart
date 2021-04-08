import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/auth/auth.dart';
import '../../injection.dart';
import 'widgets/widgets.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: BlocProvider<SignInFormBloc>(
        create: (_) => getIt<SignInFormBloc>(),
        child: SignInFormWidget(),
      ),
    );
  }
}

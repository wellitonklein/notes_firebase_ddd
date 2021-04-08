import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/auth/auth.dart';
import '../../routes/router.gr.dart';

class SignInFormWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
          () => {},
          (either) => either.fold(
            (failure) {
              FlushbarHelper.createError(
                message: failure.map(
                  cancelledByUser: (_) => 'Cancelado',
                  serverError: (_) => 'Erro no servidor',
                  emailAlreadyInUse: (_) => 'Email já está em uso',
                  invalidEmailAndPasswordCombination: (_) =>
                      'Email ou senha estão incorretos',
                ),
              ).show(context);
            },
            (_) async {
              await AutoRouter.of(context)
                  .replace(const NotesOverviewPageRoute());
              context
                  .read<AuthBloc>()
                  .add(const AuthEvent.authCheckRequested());
            },
          ),
        );
      },
      builder: (context, state) {
        return Form(
          autovalidateMode: state.showErrorMessages
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              const Text(
                '📝',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 130.0),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'E-mail',
                ),
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => context
                    .read<SignInFormBloc>()
                    .add(SignInFormEvent.emailChanged(value)),
                validator: (_) => context
                    .read<SignInFormBloc>()
                    .state
                    .emailAddress
                    .value
                    .fold(
                      (f) => f.maybeMap(
                        invalidEmail: (_) => 'Email inválido',
                        orElse: () => null,
                      ),
                      (_) => null,
                    ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.security),
                  labelText: 'Senha',
                ),
                autocorrect: false,
                obscureText: true,
                onChanged: (value) => context
                    .read<SignInFormBloc>()
                    .add(SignInFormEvent.passwordChanged(value)),
                validator: (_) =>
                    context.read<SignInFormBloc>().state.password.value.fold(
                          (f) => f.maybeMap(
                            shortPassword: (_) => 'Senha muito curta',
                            orElse: () => null,
                          ),
                          (_) => null,
                        ),
              ),
              if (!state.isSubmitting) ...[
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          context.read<SignInFormBloc>().add(
                                const SignInFormEvent
                                    .signInWithEmailAndPasswordPressed(),
                              );
                        },
                        child: Text(
                          'ENTRAR',
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          context.read<SignInFormBloc>().add(
                                const SignInFormEvent
                                    .registerWithEmailAndPasswordPressed(),
                              );
                        },
                        child: Text(
                          'CADASTRAR-SE',
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<SignInFormBloc>().add(
                          const SignInFormEvent.signInWithGooglessed(),
                        );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                  child: const Text(
                    'ENTRAR COM GOOGLE',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 8.0),
                const LinearProgressIndicator(),
              ]
            ],
          ),
        );
      },
    );
  }
}

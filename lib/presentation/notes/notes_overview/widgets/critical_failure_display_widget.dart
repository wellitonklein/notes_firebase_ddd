import 'package:flutter/material.dart';

import '../../../../domain/domain.dart';

class CriticalFailureDisplayWidget extends StatelessWidget {
  final NoteFailure failure;

  const CriticalFailureDisplayWidget({required this.failure});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('😱', style: TextStyle(fontSize: 100)),
          Text(
            failure.maybeMap(
              insufficientPermission: (_) => 'Você está sem permissão',
              orElse: () =>
                  'Erro inesperado.\nPor favor entrar em contato com suporte!',
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24.0),
          ),
          ElevatedButton(
            onPressed: () {
              // ignore: avoid_print
              print('Sending email!');
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).primaryColor,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.mail),
                SizedBox(width: 4.0),
                Text('PRECISO DE AJUDA!')
              ],
            ),
          ),
        ],
      ),
    );
  }
}

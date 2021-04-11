import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:kt_dart/kt.dart';
import 'package:provider/provider.dart';

import '../../../../application/application.dart';
import '../../../../domain/domain.dart';
import '../misc/misc.dart';

class TodoListWidget extends StatelessWidget {
  const TodoListWidget();

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (p, c) => p.note.todos.isFull != c.note.todos.isFull,
      listener: (context, state) {
        if (state.note.todos.isFull) {
          FlushbarHelper.createAction(
            message: 'Quer lista maior? Ative premium 🤩',
            button: TextButton(
              onPressed: () {
                // ignore: avoid_print
                print('COMPRAR AGORA');
              },
              child: Text(
                'ATIVAR',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
            duration: const Duration(seconds: 5),
          ).show(context);
        }
      },
      child: Consumer<FormTodos>(
        builder: (context, formTodos, child) {
          return ImplicitlyAnimatedReorderableList<TodoItemPrimitive>(
            shrinkWrap: true,
            removeDuration: Duration.zero,
            items: formTodos.value.asList(),
            areItemsTheSame: (oldItem, newItem) => oldItem!.id == newItem!.id,
            onReorderFinished: (_, __, ___, newItems) {
              context.formTodos = newItems.toImmutableList();
              context
                  .read<NoteFormBloc>()
                  .add(NoteFormEvent.todosChanged(todos: context.formTodos));
            },
            itemBuilder: (context, animation, item, index) {
              return Reorderable(
                key: ValueKey(item.id),
                builder: (context, animation, inDrag) {
                  return ScaleTransition(
                    scale: Tween<double>(
                      begin: 1,
                      end: 0.95,
                    ).animate(animation),
                    child: TodoTile(
                      index: index,
                      elevation: animation.value * 4,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class TodoTile extends HookWidget {
  final int index;
  final double elevation;
  const TodoTile({required this.index, this.elevation = 0.0});

  @override
  Widget build(BuildContext context) {
    final todo = context.formTodos.getOrElse(
      index,
      (_) => TodoItemPrimitive.empty(),
    );
    final _controller = useTextEditingController(text: todo.name);

    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      secondaryActions: [
        IconSlideAction(
          caption: 'Excluir',
          icon: Icons.delete,
          color: Colors.red,
          onTap: () {
            context.formTodos = context.formTodos.minusElement(todo);
            context
                .read<NoteFormBloc>()
                .add(NoteFormEvent.todosChanged(todos: context.formTodos));
          },
        )
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: Material(
          elevation: elevation,
          animationDuration: const Duration(milliseconds: 50),
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              leading: Checkbox(
                value: todo.done,
                onChanged: (value) {
                  context.formTodos = context.formTodos.map(
                    (listTodo) => listTodo == todo
                        ? todo.copyWith(done: value == true)
                        : listTodo,
                  );
                  context.read<NoteFormBloc>().add(
                      NoteFormEvent.todosChanged(todos: context.formTodos));
                },
              ),
              trailing: const Handle(child: Icon(Icons.menu)),
              title: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Tarefa',
                  border: InputBorder.none,
                  counterText: '',
                ),
                maxLength: TodoName.maxLength,
                onChanged: (value) {
                  context.formTodos = context.formTodos.map(
                    (listTodo) => listTodo == todo
                        ? todo.copyWith(name: value)
                        : listTodo,
                  );
                  context.read<NoteFormBloc>().add(
                      NoteFormEvent.todosChanged(todos: context.formTodos));
                },
                validator: (_) {
                  return context
                      .read<NoteFormBloc>()
                      .state
                      .note
                      .todos
                      .value
                      .fold(
                        (f) => null,
                        (todoList) => todoList[index].name.value.fold(
                              (f) => f.maybeMap(
                                empty: (_) => 'Não pode ser vazio',
                                exceedingLength: (_) =>
                                    'Descrição tem que ser menor de ${TodoName.maxLength}',
                                multiline: (_) =>
                                    'Não pode ter mais que 1 linha',
                                orElse: () => null,
                              ),
                              (_) => null,
                            ),
                      );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

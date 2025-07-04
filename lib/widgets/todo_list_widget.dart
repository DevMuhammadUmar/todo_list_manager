import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_manager/providers/todo_provider.dart';
import 'package:todo_list_manager/widgets/todo_widget.dart';

class TodoListWidget extends StatelessWidget {
  const TodoListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    final todos = provider.todos;
    return todos.isEmpty
        ? Center(
            child: Text('No todos yet. Add your first todo!',
                style: TextStyle(color: Colors.grey)),
          )
        : ListView.separated(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(2),
            itemCount: todos.length,
            separatorBuilder: (context, index) => Container(
                  height: 3,
                ),
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoWidget(todo: todo);
            });
  }
}

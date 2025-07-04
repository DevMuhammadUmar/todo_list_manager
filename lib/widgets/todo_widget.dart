import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_manager/models/todo_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list_manager/pages/edit_todo_page.dart';
import 'package:todo_list_manager/providers/theme_provider.dart';
import 'package:todo_list_manager/providers/todo_provider.dart';

class TodoWidget extends StatelessWidget {
  final Todo todo;
  const TodoWidget({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    Widget buildTodo() => Container(
          padding: const EdgeInsets.all(20),
          color: themeProvider.isDarkMode
              ? const Color.fromARGB(255, 17, 20, 18)
              : Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: Checkbox(
                  activeColor: const Color.fromARGB(255, 69, 121, 71),
                  checkColor: Colors.white,
                  value: todo.isCompleted,
                  onChanged: (bool? value) {
                    if (value != null) {
                      final provider =
                          Provider.of<TodoProvider>(context, listen: false);
                      provider.toggleTodoCompletion(todo);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(value
                              ? 'Todo marked as completed'
                              : 'Todo marked as incomplete'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: themeProvider.isDarkMode
                              ? const Color.fromARGB(255, 69, 121, 71)
                              : const Color.fromARGB(255, 69, 121, 71),
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      if (todo.description.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            todo.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: themeProvider.isDarkMode
                                  ? const Color.fromARGB(255, 69, 121, 71)
                                      .withOpacity(0.7)
                                  : const Color.fromARGB(255, 69, 121, 71)
                                      .withOpacity(0.7),
                              decoration: todo.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          "Due: ${DateFormat.yMMMMd().format(todo.date)}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: themeProvider.isDarkMode
                                ? const Color.fromARGB(255, 69, 121, 71)
                                : const Color.fromARGB(255, 69, 121, 71),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );

    return Slidable(
      key: ValueKey(todo.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () => delTodo(context),
        ),
        children: [
          SlidableAction(
            onPressed: (context) => editTodo(context),
            backgroundColor: const Color.fromARGB(255, 95, 165, 97),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) => delTodo(context),
            backgroundColor: const Color.fromARGB(255, 233, 81, 81),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: buildTodo(),
    );
  }

  void delTodo(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: Text('Are you sure you want to delete "${todo.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                final provider =
                    Provider.of<TodoProvider>(context, listen: false);
                provider.deleteTodo(todo.id);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Todo deleted'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void editTodo(BuildContext context) {
     Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditTodoPage(todo: todo),
    ),
  );
  }
}

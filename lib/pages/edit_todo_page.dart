import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_manager/models/todo_model.dart';
import 'package:todo_list_manager/providers/theme_provider.dart';
import 'package:todo_list_manager/providers/todo_provider.dart';

class EditTodoPage extends StatefulWidget {
  final Todo todo;

  const EditTodoPage({super.key, required this.todo});

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.todo.title;
    _descriptionController.text = widget.todo.description;
    selectedDate = widget.todo.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Todo",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                  'Due Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final newDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (newDate != null) {
                  setState(() {
                    selectedDate = newDate;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  final updatedTodo = Todo(
                    id: widget.todo.id,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    date: selectedDate,
                    isCompleted: widget.todo.isCompleted,
                  );

                  Provider.of<TodoProvider>(context, listen: false)
                      .editTodo(updatedTodo);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Todo updated successfully!'),
                      backgroundColor: themeProvider.isDarkMode
                          ? const Color.fromARGB(
                              255, 69, 121, 71) // Lime green for dark mode
                          : const Color.fromARGB(255, 69, 121, 71),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.isDarkMode
                    ? const Color.fromARGB(
                        255, 69, 121, 71) // Lime green for dark mode
                    : const Color.fromARGB(255, 69, 121, 71),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoWidget extends StatelessWidget {
  final Todo todo;

  const TodoWidget({super.key, required this.todo});

  void editTodo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTodoPage(todo: todo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

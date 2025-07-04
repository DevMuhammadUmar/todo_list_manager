import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_manager/models/todo_model.dart';
import 'package:todo_list_manager/providers/todo_provider.dart';
import 'package:uuid/uuid.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void addTodoitem() {
    if (_titleController.text.isNotEmpty) {
      final todo = Todo(
          id: const Uuid().v4(),
          title: _titleController.text,
          description: _descriptionController.text,
          date: selectedDate);
      final provider = Provider.of<TodoProvider>(context, listen: false);

      provider.addTodo(todo);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todo added successfully!'),
          backgroundColor: Color.fromARGB(255, 69, 121, 71),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.of(context).pop();
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (newDate != null) {
      setState(() {
        selectedDate = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Todo",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
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
              onTap: () => pickDate(context),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addTodoitem,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 69, 121, 71),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Add Todo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

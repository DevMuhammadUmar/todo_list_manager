import 'package:flutter/material.dart';

class TodoForm extends StatelessWidget {
  const TodoForm({
    super.key,
    required this.title,
    required this.description,
    required this.selectedDate,
    required this.onChangeTitle,
    required this.onChangeDescription,
    required this.onDatePicked,
    required this.onSavedTodo,
  });

  final String title;
  final String description;
  final DateTime? selectedDate;
  final ValueChanged<String> onChangeTitle;
  final ValueChanged<String> onChangeDescription;
  final VoidCallback onDatePicked;
  final VoidCallback onSavedTodo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTitle(),
        buildDescription(),
        const SizedBox(height: 24),
        buildDatePicker(context),
        const SizedBox(height: 24),
        buildButton(),
      ],
    );
  }

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        onChanged: onChangeTitle,
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: "Title",
        ),
      );

  Widget buildDescription() => TextFormField(
        maxLines: 3,
        initialValue: description,
        onChanged: onChangeDescription,
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: "Description",
        ),
      );

  Widget buildDatePicker(BuildContext context) => GestureDetector(
        onTap: onDatePicked,
        child: InputDecorator(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: "Due Date",
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 20),
              const SizedBox(width: 8),
              Text(
                selectedDate != null
                    ? "${selectedDate!.toLocal()}".split(' ')[0]
                    : "Select a date",
                style: TextStyle(
                  fontSize: 16,
                  color: selectedDate != null ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildButton() => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          onPressed: onSavedTodo,
          child: const Text(
            "Add",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
}

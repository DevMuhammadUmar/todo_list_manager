import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/todo_model.dart';
import '../services/database_helper.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Todo> get todos => _todos.where((todo) => !todo.isCompleted).toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  List<Todo> get completedTodos =>
      _todos.where((todo) => todo.isCompleted).toList()
        ..sort((a, b) => a.date.compareTo(b.date));

  Future<void> initializeAsync() async {
    await loadTodos();
  }

  Future<void> loadTodos() async {
    _todos = await _databaseHelper.getTodos();

    if (_todos.isEmpty) {
      await _addSampleData();
      _todos = await _databaseHelper.getTodos();
    }
    notifyListeners();
  }

  Future<void> _addSampleData() async {
    final sampleTodos = [
      Todo(
        id: const Uuid().v4(),
        title: "Buy groceries",
        description: "Milk, Eggs, Bread, Coffee",
        date: DateTime.now(),
      ),
    ];

    for (Todo todo in sampleTodos) {
      await _databaseHelper.insertTodo(todo);
    }
  }

  Future<void> addTodo(Todo todo) async {
    await _databaseHelper.insertTodo(todo);
    _todos.add(todo);
    notifyListeners();
  }

  Future<void> deleteTodo(String id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) return;

    await _databaseHelper.deleteTodo(id);
    _todos.removeAt(index);
    notifyListeners();
  }

  Future<void> editTodo(Todo updatedTodo) async {
    final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index == -1) return;

    await _databaseHelper.updateTodo(updatedTodo);
    _todos[index] = updatedTodo;
    notifyListeners();
  }

  Future<bool> toggleTodoCompletion(Todo todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index == -1) return todo.isCompleted;

    final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
    await _databaseHelper.updateTodo(updatedTodo);
    _todos[index] = updatedTodo;
    notifyListeners();
    return updatedTodo.isCompleted;
  }
}

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqflite_todos/models/todo_model.dart';
import 'package:flutter_sqflite_todos/screens/add_todo_screen.dart';
import 'package:flutter_sqflite_todos/services/database_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sqflite_todos/extensions/string_extension.dart';

class TodoTile extends StatelessWidget {
  final VoidCallback updateTodos;
  final Todo todo;

  const TodoTile({
    required this.updateTodos,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    final completedTextDecoration =
        !todo.completed ? TextDecoration.none : TextDecoration.lineThrough;
    return ListTile(
      key: Key(todo.id.toString()),
      title: Text(
        todo.name,
        style: TextStyle(
          fontSize: 18.0,
          decoration: completedTextDecoration,
        ),
      ),
      subtitle: Row(
        children: [
          Text(
            '${DateFormat.MMMMEEEEd().format(todo.date)} • ',
            style: TextStyle(
              height: 1.3,
              decoration: completedTextDecoration,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 2.5,
              horizontal: 8.0,
            ),
            decoration: BoxDecoration(
              color: _getColor(),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 2),
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: Text(
              EnumToString.convertToString(todo.priorityLevel).capitalize(),
              style: TextStyle(
                color: !todo.completed ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                decoration: completedTextDecoration,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      trailing: Checkbox(
        value: todo.completed,
        activeColor: _getColor(),
        onChanged: (value) {
          DatabaseService.instance.update(todo.copyWith(completed: value));
          updateTodos();
        },
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => AddTodoScreen(
            updateTodos: updateTodos,
            todo: todo,
          ),
        ),
      ),
    );
  }

  Color _getColor() {
    switch (todo.priorityLevel) {
      case PriorityLevel.low:
        return Colors.green;
      case PriorityLevel.medium:
        return Colors.orange[600]!;
      case PriorityLevel.high:
        return Colors.red[400]!;
    }
  }
}

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqflite_todos/models/todo_model.dart';
import 'package:flutter_sqflite_todos/extensions/string_extension.dart';
import 'package:intl/intl.dart';

class AddTodoScreen extends StatefulWidget {
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _dateController;

  Todo? _todo;

  @override
  void initState() {
    super.initState();
    _todo = Todo(
      name: '',
      date: DateTime.now(),
      priorityLevel: PriorityLevel.medium,
      completed: false,
    );

    _nameController = TextEditingController(text: _todo!.name);
    _dateController =
        TextEditingController(text: DateFormat.MMMMEEEEd().format(_todo!.date));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 40.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(fontSize: 16.0),
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value!.trim().isEmpty ? 'Please enter a name' : null,
                  onSaved: (value) => _todo = _todo!.copyWith(name: value),
                ),
                const SizedBox(height: 32.0),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  style: const TextStyle(fontSize: 16.0),
                  decoration: const InputDecoration(labelText: 'Date'),
                  onTap: _handleDatePicker,
                ),
                const SizedBox(height: 32.0),
                DropdownButtonFormField<PriorityLevel>(
                  value: _todo!.priorityLevel,
                  icon: const Icon(Icons.arrow_drop_down_circle),
                  iconSize: 22.0,
                  iconEnabledColor: Theme.of(context).primaryColor,
                  items: PriorityLevel.values
                      .map((priorityLevel) => DropdownMenuItem(
                            value: priorityLevel,
                            child: Text(
                              EnumToString.convertToString(priorityLevel)
                                  .capitalize(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                          ))
                      .toList(),
                  style: const TextStyle(fontSize: 16.0),
                  decoration:
                      const InputDecoration(labelText: 'Priority Level'),
                  onChanged: (value) => setState(
                    () => _todo = _todo!.copyWith(priorityLevel: value),
                  ),
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    minimumSize: const Size.fromHeight(45.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    'Add',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleDatePicker() {}
}

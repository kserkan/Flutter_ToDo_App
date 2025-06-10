import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';


import '../models/todo_model.dart';
import '../services/firestore_service.dart';

class AddTodoModal extends StatefulWidget {
  const AddTodoModal({super.key});

  @override
  State<AddTodoModal> createState() => _AddTodoModalState();
}

class _AddTodoModalState extends State<AddTodoModal> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _icons = ['work', 'home', 'school', 'fitness', 'music', 'book', 'travel', 'shopping', 'event', 'code'];
  String _selectedIcon = 'work';
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField(
            value: _selectedIcon,
            items: _icons.map((icon) {
              return DropdownMenuItem(value: icon, child: Text(icon));
            }).toList(),
            onChanged: (val) => setState(() => _selectedIcon = val!),
            decoration: const InputDecoration(labelText: "İkon Seç"),
          ),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: "Başlık"),
          ),
          TextField(
            controller: _subtitleController,
            decoration: const InputDecoration(labelText: "Alt Başlık"),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(_selectedDate == null
                  ? "Tarih seçilmedi"
                  : "Seçilen: ${_selectedDate!.toLocal().toString().split(' ')[0]}"),
              const Spacer(),
              TextButton(
                onPressed: () {
                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      onConfirm: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      });
                },
                child: const Text("Tarih Seç"),
              )
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (_titleController.text.isEmpty || _selectedDate == null) return;

              final newTodo = TodoModel(
                id: const Uuid().v4(),
                title: _titleController.text,
                subtitle: _subtitleController.text,
                icon: _selectedIcon,
                time: _selectedDate!,
                isDone: false,
              );

              await FirestoreService().addTodo(newTodo);
              Navigator.pop(context);
            },
            child: const Text("Todo Ekle"),
          )
        ],
      ),
    );
  }
}

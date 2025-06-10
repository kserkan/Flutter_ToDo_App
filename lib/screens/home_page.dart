import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/firestore_service.dart';
import '../widgets/add_todo_modal.dart';
import '../models/todo_model.dart';
import '../constants/icon_map.dart'; // ikon eşlemesi için


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return Scaffold(
      appBar: AppBar(
  title: const Text("Yapılacaklar"),
  actions: [
    Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) => Switch(
        value: themeProvider.isDarkMode,
        onChanged: themeProvider.toggleTheme,
        activeColor: Colors.white,
      ),
    ),
  ],
),
      body: StreamBuilder<List<TodoModel>>(
        stream: firestore.getTodosStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Hata oluştu"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final todos = snapshot.data!;
          if (todos.isEmpty) {
            return const Center(child: Text("Henüz todo eklenmemiş"));
          }

          return ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) {
    final todo = todos[index];
    return Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  elevation: 3,
  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  child: Padding(
    padding: const EdgeInsets.all(12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          iconMap[todo.icon] ?? Icons.circle,
          color: Colors.blue,
          size: 32,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                todo.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: todo.isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: todo.isDone
                      ? Colors.grey
                      : Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                todo.subtitle,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "🕒 ${todo.time.toLocal().toString().substring(0, 16)}",
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Checkbox(
              value: todo.isDone,
              onChanged: (val) {
                firestore.updateTodoStatus(todo.id, val ?? false);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => firestore.deleteTodo(todo.id),
            ),
          ],
        ),
      ],
    ),
  ),
);


  },
);

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const AddTodoModal(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

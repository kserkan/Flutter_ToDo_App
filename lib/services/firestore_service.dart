import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_model.dart';

class FirestoreService {
  final CollectionReference _todoRef =
      FirebaseFirestore.instance.collection('todos');

  //ekle
  Future<void> addTodo(TodoModel todo) async {
    await _todoRef.doc(todo.id).set(todo.toMap());
  }

  //güncelle
  Future<void> updateTodoStatus(String id, bool isDone) async {
    await _todoRef.doc(id).update({'isDone': isDone});
  }

  // sil
  Future<void> deleteTodo(String id) async {
    await _todoRef.doc(id).delete();
  }

  //listeleme
  Stream<List<TodoModel>> getTodosStream() {
    return _todoRef.orderBy('time').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TodoModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}

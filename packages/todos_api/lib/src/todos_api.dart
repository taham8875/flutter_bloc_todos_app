import 'package:todos_api/models/todo.dart';

abstract class TodosApi {
  const TodosApi();
  Stream<List<Todo>> getTodos();
  Future<void> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
  Future<int> deleteCompletedTodos();
  Future<void> deleteAllTodos();
  Future<int> completedTodos();
  Future<int> completeAll({required bool isCompleted});
  Future<void> close();
}

class TodoNotFoundException implements Exception {}
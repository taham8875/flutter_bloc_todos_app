import 'package:todos_api/models/todo.dart';
import 'package:todos_api/src/todos_api.dart';

class TodosRepository {
  final TodosApi _todosApi;

  const TodosRepository({
    required TodosApi todosApi,
  }) : _todosApi = todosApi;

  Stream<List<Todo>> getTodos() {
    return _todosApi.getTodos();
  }

  Future<void> addTodo(Todo todo) {
    return _todosApi.addTodo(todo);
  }

  Future<void> updateTodo(Todo todo) {
    return _todosApi.updateTodo(todo);
  }

  Future<void> deleteTodo(String id) {
    return _todosApi.deleteTodo(id);
  }

  Future<void> deleteAllTodos() {
    return _todosApi.deleteAllTodos();
  }

  Future<int> completedTodos() {
    return _todosApi.completedTodos();
  }

  Future<int> completeAll({required bool isCompleted}) {
    return _todosApi.completeAll(isCompleted: isCompleted);
  }
}

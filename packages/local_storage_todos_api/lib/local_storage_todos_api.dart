import 'dart:async';
import 'dart:convert';

import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_api/models/todo.dart';
import 'package:todos_api/src/todos_api.dart';

class LocalStorageTodosApi extends TodosApi {
  final SharedPreferences _prefs;
  List<Todo> todos = [];
  late final _todoStreamController = BehaviorSubject<List<Todo>>.seeded(
    const [],
  );
  final _kTodosCollectionKey = '__todos_collection_key__';

  LocalStorageTodosApi({
    required SharedPreferences prefs,
  }) : _prefs = prefs {
    _init();
  }

  void _init() {
    final todosJson = _prefs.getString(_kTodosCollectionKey);
    if (todosJson != null) {
      todos = List<Map<dynamic, dynamic>>.from(
        json.decode(todosJson) as List,
      )
          .map((jsonMap) => Todo.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _todoStreamController.add(todos);
    } else {
      _todoStreamController.add([]);
    }
  }

  @override
  Stream<List<Todo>> getTodos() {
    return _todoStreamController.asBroadcastStream();
  }

  @override
  Future<void> addTodo(Todo todo) async {
    final todos = [..._todoStreamController.value, todo];
    _todoStreamController.add(todos);
    _prefs.setString(
      _kTodosCollectionKey,
      json.encode(todos),
    );
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((element) => element.id == todo.id);
    if (todoIndex == -1) {
      throw TodoNotFoundException();
    }
    todos[todoIndex] = todo;
    _todoStreamController.add(todos);
    _prefs.setString(
      _kTodosCollectionKey,
      json.encode(todos),
    );
  }

  @override
  Future<void> deleteTodo(String id) async {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((element) => element.id == id);
    if (todoIndex == -1) {
      throw TodoNotFoundException();
    }
    todos.removeAt(todoIndex);
    _todoStreamController.add(todos);
    _prefs.setString(
      _kTodosCollectionKey,
      json.encode(todos),
    );
  }

  @override
  Future<void> deleteAllTodos() async {
    _todoStreamController.add([]);
    _prefs.remove(_kTodosCollectionKey);
  }

  @override
  Future<int> completedTodos() async {
    final todos = [..._todoStreamController.value];
    final completedTodosAmount = todos.where((todo) => todo.isCompleted).length;
    return completedTodosAmount;
  }

  @override
  Future<int> completeAll({required bool isCompleted}) async {
    final todos = [..._todoStreamController.value];
    final changedTodosAmount = todos.where((todo) => todo.isCompleted != isCompleted).length;
    final newTodos = todos.map((todo) => todo.copyWith(isCompleted: isCompleted)).toList();
    _todoStreamController.add(newTodos);
    _prefs.setString(
      _kTodosCollectionKey,
      json.encode(newTodos),
    );
    return changedTodosAmount;
  }

  @override
  Future<void> close() {
    return _todoStreamController.close();
  }
  
  @override
  Future<int> deleteCompletedTodos() async {
    final todos = [..._todoStreamController.value];
    final completedTodosAmount = todos.where((todo) => todo.isCompleted).length;
    todos.removeWhere((todo) => todo.isCompleted);
    _todoStreamController.add(todos);
    _prefs.setString(
      _kTodosCollectionKey,
      json.encode(todos),
    );
    return completedTodosAmount;
  }
}

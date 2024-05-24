import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_api/models/todo.dart';
import 'package:todos_api/src/todos_api.dart';
import 'package:uuid/uuid.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final LocalStorageTodosApi todosApi =
      LocalStorageTodosApi(prefs: sharedPreferences);
  const uuid = Uuid();

  group('localStorageTodosApi', () {
    tearDown(() {
      todosApi.deleteAllTodos();
    });

    test('getTodos returns an empty list initially', () async {
      expect(todosApi.getTodos(), emits([]));
    });

    test('addTodo adds a new todo', () async {
      final todo = Todo(
        id: uuid.v4(),
        title: 'addTodo Todo',
        description: 'addTodo Description',
        isCompleted: false,
      );

      await todosApi.addTodo(todo);

      expect(todosApi.getTodos(), emits([todo]));
    });

    test('updateTodo updates an existing todo', () async {
      final todo = Todo(
        id: uuid.v4(),
        title: 'updateTodo Todo',
        description: 'updateTodo Description',
        isCompleted: false,
      );

      await todosApi.addTodo(todo);

      final updatedTodo = todo.copyWith(title: 'I am an updated');
      await todosApi.updateTodo(updatedTodo);

      expect(todosApi.getTodos(), emits([updatedTodo]));
    });

    test('updateTodo throws TodoNotFoundException if todo does not exist',
        () async {
      const todo = Todo(
        id: '1',
        title: 'Test Todo',
        description: 'Test Description',
        isCompleted: false,
      );

      expect(() => todosApi.updateTodo(todo),
          throwsA(isA<TodoNotFoundException>()));
    });

    test('deleteTodo removes an existing todo', () async {
      final todo = Todo(
        id: uuid.v4(),
        title: 'Test Todo',
        description: 'Test Description',
        isCompleted: false,
      );

      await todosApi.addTodo(todo);

      await todosApi.deleteTodo(todo.id);

      expect(todosApi.getTodos(), emits([]));
    });

    test('completedTodos returns the count of completed todos', () async {
      final todo1 = Todo(
        id: uuid.v4(),
        title: 'Test Todo 1',
        description: 'Test Description 1',
        isCompleted: true,
      );
      final todo2 = Todo(
        id: uuid.v4(),
        title: 'Test Todo 2',
        description: 'Test Description 2',
        isCompleted: false,
      );
      final todo3 = Todo(
        id: uuid.v4(),
        title: 'Test Todo 3',
        description: 'Test Description 3',
        isCompleted: true,
      );

      await todosApi.addTodo(todo1);
      await todosApi.addTodo(todo2);
      await todosApi.addTodo(todo3);

      final count = await todosApi.completedTodos();

      expect(count, 2);
    });

    test('completeAll marks all todos as completed', () async {
      final todo1 = Todo(
        id: uuid.v4(),
        title: 'Test Todo 1',
        description: 'Test Description 1',
        isCompleted: false,
      );
      final todo2 = Todo(
        id: uuid.v4(),
        title: 'Test Todo 2',
        description: 'Test Description 2',
        isCompleted: false,
      );
      final todo3 = Todo(
        id: uuid.v4(),
        title: 'Test Todo 3',
        description: 'Test Description 3',
        isCompleted: false,
      );

      await todosApi.addTodo(todo1);
      await todosApi.addTodo(todo2);
      await todosApi.addTodo(todo3);

      final count = await todosApi.completeAll(isCompleted: true);

      expect(count, 3);
      expect(
          todosApi.getTodos(),
          emits([
            todo1.copyWith(isCompleted: true),
            todo2.copyWith(isCompleted: true),
            todo3.copyWith(isCompleted: true)
          ]));
    });
  });
}

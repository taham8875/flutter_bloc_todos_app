import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_todos_app/todos_overview/models/todos_view_filter.dart';
import 'package:todos_api/models/todo.dart';
import 'package:todos_repository/src/todos_repository.dart';

part 'todos_overview_event.dart';
part 'todos_overview_state.dart';

class TodosOverviewBloc extends Bloc<TodosOverviewEvent, TodosOverviewState> {
  final TodosRepository _todosRepository;
  TodosOverviewBloc({
    required TodosRepository todosRepository,
  })  : _todosRepository = todosRepository,
        super(const TodosOverviewState()) {
    on<TodosOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<TodosOverviewTodoCompletionToggled>(_onTodoCompletionToggled);
    on<TodosOverviewTodoDeleted>(_onTodoDeleted);
    on<TodosOverviewUndoDeletionRequested>(_onUndoDeletionRequested);
    on<TodosOverviewFilterChanged>(_onFilterChanged);
    on<TodosOverviewToggleAllRequested>(_onToggleAllRequested);
    on<TodosOverviewDeleteCompleteRequested>(_onDeleteCompleteRequested);
  }

  Future<void> _onSubscriptionRequested(
    TodosOverviewSubscriptionRequested event,
    Emitter<TodosOverviewState> emit,
  ) async {
    emit(state.copyWith(
      status: TodosOverviewStatus.loading,
    ));

    await emit.forEach<List<Todo>>(
      _todosRepository.getTodos(),
      onData: (todos) => state.copyWith(
        status: TodosOverviewStatus.success,
        todos:  todos,
      ),
      onError: (_, __) => state.copyWith(
        status:  TodosOverviewStatus.failure,
      ),
    );
  }

  Future<void> _onTodoCompletionToggled(
    TodosOverviewTodoCompletionToggled event,
    Emitter<TodosOverviewState> emit,
  ) async {
    final updatedTodo = event.todo.copyWith(isCompleted: event.isCompleted);
    _todosRepository.updateTodo(updatedTodo);
  }

  Future<void> _onTodoDeleted(
    TodosOverviewTodoDeleted event,
    Emitter<TodosOverviewState> emit,
  ) async {
    emit(state.copyWith(
      lastDeletedTodo: event.todo,
    ));
    _todosRepository.deleteTodo(event.todo.id);
  }

  Future<void> _onUndoDeletionRequested(
    TodosOverviewUndoDeletionRequested event,
    Emitter<TodosOverviewState> emit,
  ) async {
    if (state.lastDeletedTodo == null) return;
    final todo = state.lastDeletedTodo!;
    _todosRepository.addTodo(todo);
    emit(state.copyWith(
      lastDeletedTodo: null,
    ));
  }
  
  Future<void> _onFilterChanged(
    TodosOverviewFilterChanged event,
    Emitter<TodosOverviewState> emit,
  ) async {
    emit(state.copyWith(
      filter: event.filter,
    ));
  }
  
  Future<void> _onToggleAllRequested(
    TodosOverviewToggleAllRequested event,
    Emitter<TodosOverviewState> emit,
  ) async {
    final areAllCompleted = state.todos.every((todo) => todo.isCompleted);
    final updatedTodos = state.todos.map((todo) => todo.copyWith(isCompleted: !areAllCompleted)).toList();
    updatedTodos.forEach(_todosRepository.updateTodo);
  }

  Future<void> _onDeleteCompleteRequested(
    TodosOverviewDeleteCompleteRequested event,
    Emitter<TodosOverviewState> emit,
  ) async {
    final completedTodos = state.todos.where((todo) => todo.isCompleted).toList();
    completedTodos.forEach((todo) => _todosRepository.deleteTodo(todo.id));
  }
}

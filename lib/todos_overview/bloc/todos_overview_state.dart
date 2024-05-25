part of 'todos_overview_bloc.dart';

enum TodosOverviewStatus { initial, loading, success, failure }

final class TodosOverviewState extends Equatable {
  final TodosOverviewStatus status;
  final List<Todo> todos;
  final TodosViewFilter filter;
  final Todo? lastDeletedTodo;

  const TodosOverviewState({
    this.status = TodosOverviewStatus.initial,
    this.todos = const [],
    this.filter = TodosViewFilter.all,
    this.lastDeletedTodo,
  });

  get filteredTodos => filter.applyAll(todos);

  TodosOverviewState copyWith({
    TodosOverviewStatus? status,
    List<Todo>? todos,
    TodosViewFilter? filter,
    Todo? lastDeletedTodo,
  }) {
    return TodosOverviewState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      filter: filter ?? this.filter,
      lastDeletedTodo: lastDeletedTodo ?? this.lastDeletedTodo,
    );
  }

  @override
  List<Object?> get props => [status, todos, filter, lastDeletedTodo];
}

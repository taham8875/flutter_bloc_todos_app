part of 'todos_overview_bloc.dart';

sealed class TodosOverviewEvent extends Equatable {
  const TodosOverviewEvent();

  @override
  List<Object> get props => [];
}

final class TodosOverviewSubscriptionRequested extends TodosOverviewEvent {
  const TodosOverviewSubscriptionRequested();
}

final class TodosOverviewTodoCompletionToggled extends TodosOverviewEvent {
  final Todo todo;
  final bool isCompleted;

  const TodosOverviewTodoCompletionToggled({
    required this.todo,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [todo, isCompleted];
}

final class TodosOverviewTodoDeleted extends TodosOverviewEvent {
  final Todo todo;

  const TodosOverviewTodoDeleted({
    required this.todo,
  });

  @override
  List<Object> get props => [todo];
}

final class TodosOverviewUndoDeletionRequested extends TodosOverviewEvent {
  const TodosOverviewUndoDeletionRequested();
}

class TodosOverviewFilterChanged extends TodosOverviewEvent {
  final TodosViewFilter filter;

  const TodosOverviewFilterChanged(this.filter);

  @override
  List<Object> get props => [filter];
}

class TodosOverviewToggleAllRequested extends TodosOverviewEvent {
  const TodosOverviewToggleAllRequested();
}

class TodosOverviewDeleteCompleteRequested extends TodosOverviewEvent {
  const TodosOverviewDeleteCompleteRequested();
}
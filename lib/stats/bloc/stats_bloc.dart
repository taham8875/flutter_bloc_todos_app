import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todos_api/models/todo.dart';
import 'package:todos_repository/src/todos_repository.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final TodosRepository _todosRepository;
  StatsBloc({
    required TodosRepository todosRepository,
  })  : _todosRepository = todosRepository,
        super(StatsInitial()) {
    on<StatsSubscriptionRequested>(_onSubscriptionRequested);
  }
  Future<void> _onSubscriptionRequested(
    StatsSubscriptionRequested event,
    Emitter<StatsState> emit,
  ) async {
    emit(state.copyWith(status: StatsStatus.loading));

    await emit.forEach<List<Todo>>(
      _todosRepository.getTodos(),
      onData: (todos) => state.copyWith(
        status: StatsStatus.success,
        completedTodos: todos.where((todo) => todo.isCompleted).length,
        activeTodos: todos.where((todo) => !todo.isCompleted).length,
      ),
      onError: (_, __) => state.copyWith(status: StatsStatus.failure),
    );
  }
}

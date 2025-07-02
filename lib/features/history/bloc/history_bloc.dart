import 'package:flutter_bloc/flutter_bloc.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    on<LoadHistoryEvent>(_onLoadHistory);
  }

  Future<void> _onLoadHistory(LoadHistoryEvent event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    await Future.delayed(const Duration(seconds: 1));
    // Mock data, thay bằng lấy dữ liệu thực tế nếu có
    final historyList = [
      'Order #1 - 2025-07-01',
      'Order #2 - 2025-06-28',
      'Order #3 - 2025-06-20',
    ];
    emit(HistoryLoaded(historyList: historyList));
  }
}

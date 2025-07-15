import 'package:flutter_bloc/flutter_bloc.dart';
import 'history_event.dart';
import 'history_state.dart';
import '../domain/history_repo.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository _historyRepository;

  HistoryBloc({HistoryRepository? historyRepository})
      : _historyRepository = historyRepository ?? HistoryRepository(),
        super(HistoryInitial()) {
    on<LoadHistoryEvent>(_onLoadHistory);
  }

  Future<void> _onLoadHistory(LoadHistoryEvent event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    
    try {
      final historyList = await _historyRepository.getOrderHistory();
      
      // Convert HistoryModel to String format for compatibility
      final historyStringList = historyList.map((order) {
        return 'Order ${order.orderId} - ${_formatDate(order.date)} - ${_formatAmount(order.totalAmount)}';
      }).toList();
      
      emit(HistoryLoaded(historyList: historyStringList));
    } catch (e) {
      emit(const HistoryError(message: 'Failed to load order history'));
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    ) + 'đ';
  }
}

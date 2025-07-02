import 'package:equatable/equatable.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}
class HistoryLoading extends HistoryState {}
class HistoryLoaded extends HistoryState {
  final List<String> historyList; // Thay bằng model thực tế nếu có
  const HistoryLoaded({required this.historyList});

  @override
  List<Object?> get props => [historyList];
}
class HistoryError extends HistoryState {
  final String message;
  const HistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}

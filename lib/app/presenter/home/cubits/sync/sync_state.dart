part of 'sync_cubit.dart';

sealed class SyncState extends Equatable {
  const SyncState();

  @override
  List<Object> get props => [];
}

final class SyncInitial extends SyncState {
  final int itemsToSync;

  const SyncInitial({this.itemsToSync = 0});

  @override
  List<Object> get props => [itemsToSync];
}

final class SyncLoading extends SyncState {}

final class SyncSuccess extends SyncState {}

final class SyncError extends SyncState {
  final String message;

  const SyncError(this.message);

  @override
  List<Object> get props => [message];
}

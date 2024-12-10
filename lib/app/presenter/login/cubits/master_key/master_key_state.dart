part of 'master_key_cubit.dart';

sealed class MasterKeyState extends Equatable {
  const MasterKeyState();

  @override
  List<Object> get props => [];
}

final class MasterKeyInitial extends MasterKeyState {}

final class MasterKeyLoading extends MasterKeyState {}

final class MasterKeySuccess extends MasterKeyState {
  final bool hasKey;

  const MasterKeySuccess({required this.hasKey});

  @override
  List<Object> get props => [hasKey];
}

final class MasterKeyError extends MasterKeyState {
  final String message;

  const MasterKeyError({required this.message});

  @override
  List<Object> get props => [message];
}

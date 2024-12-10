part of 'coleta_from_storage_cubit.dart';

sealed class ColetaFromStorageState extends Equatable {
  const ColetaFromStorageState();

  @override
  List<Object> get props => [];
}

final class ColetaFromStorageInitial extends ColetaFromStorageState {}

final class ColetaFromStorageLoading extends ColetaFromStorageState {}

final class ColetaFromStorageSuccess extends ColetaFromStorageState {
  final List<ColetaModel> coletas;

  const ColetaFromStorageSuccess({required this.coletas});

  @override
  List<Object> get props => [coletas.length];
}

final class ColetaFromStorageEmpty extends ColetaFromStorageState {}

final class ColetaFromStorageError extends ColetaFromStorageState {
  final String message;

  const ColetaFromStorageError({required this.message});

  @override
  List<Object> get props => [message];
}

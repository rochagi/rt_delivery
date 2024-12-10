part of 'get_coleta_from_api_cubit.dart';

sealed class GetColetaFromApiState extends Equatable {
  const GetColetaFromApiState();

  @override
  List<Object> get props => [];
}

final class GetColetaFromApiInitial extends GetColetaFromApiState {}

final class GetColetaFromApiLoading extends GetColetaFromApiState {}

final class GetColetaFromApiSuccess extends GetColetaFromApiState {}

final class GetColetaFromApiError extends GetColetaFromApiState {
  final String message;

  const GetColetaFromApiError({required this.message});

  @override
  List<Object> get props => [message];
}

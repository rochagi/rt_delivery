part of 'get_lista_cubit.dart';

sealed class GetListaState extends Equatable {
  const GetListaState();

  @override
  List<Object> get props => [];
}

final class GetListaInitial extends GetListaState {}

final class GetListaLoading extends GetListaState {}

final class GetListaSuccess extends GetListaState {
  final ListaModel lista;

  const GetListaSuccess({required this.lista});

  @override
  List<Object> get props => [lista.lista!];
}

final class GetListaEmpty extends GetListaState {}

final class GetListaError extends GetListaState {
  final String message;

  const GetListaError({required this.message});

  @override
  List<Object> get props => [message];
}

part of 'get_hawbs_cubit.dart';

sealed class GetHawbsState extends Equatable {
  const GetHawbsState();

  @override
  List<Object> get props => [];
}

final class GetHawbsInitial extends GetHawbsState {}

final class GetHawbsLoading extends GetHawbsState {}

final class GetHawbsSuccess extends GetHawbsState {
  final List<HawbModel> hawbs;

  const GetHawbsSuccess(this.hawbs);

  @override
  List<Object> get props => [hawbs.length];
}

final class GetHawbsFailure extends GetHawbsState {
  final String message;

  const GetHawbsFailure(this.message);

  @override
  List<Object> get props => [message];
}

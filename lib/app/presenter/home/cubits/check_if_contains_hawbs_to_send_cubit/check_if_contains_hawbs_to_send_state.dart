part of 'check_if_contains_hawbs_to_send_cubit.dart';

sealed class CheckIfContainsHawbsToSendState extends Equatable {
  const CheckIfContainsHawbsToSendState();

  @override
  List<Object> get props => [];
}

final class CheckIfContainsHawbsToSendInitial
    extends CheckIfContainsHawbsToSendState {}

final class CheckIfContainsHawbsToSendLoading
    extends CheckIfContainsHawbsToSendState {}

final class CheckIfContainsHawbsToSendSuccess
    extends CheckIfContainsHawbsToSendState {
  final bool containsHawbs;

  const CheckIfContainsHawbsToSendSuccess({required this.containsHawbs});

  @override
  List<Object> get props => [containsHawbs];
}

final class CheckIfContainsHawbsToSendError
    extends CheckIfContainsHawbsToSendState {
  final String message;

  const CheckIfContainsHawbsToSendError({required this.message});

  @override
  List<Object> get props => [message];
}

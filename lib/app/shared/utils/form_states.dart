import 'package:equatable/equatable.dart';

abstract class FormStates extends Equatable {}

class FormInitial extends FormStates {
  @override
  List<Object?> get props => [];
}

class FormLoading extends FormStates {
  @override
  List<Object?> get props => [];
}

class FormSuccess extends FormStates {
  @override
  List<Object?> get props => [];
}

class FormError extends FormStates {
  final String message;

  FormError(this.message);

  @override
  List<Object?> get props => [message];
}

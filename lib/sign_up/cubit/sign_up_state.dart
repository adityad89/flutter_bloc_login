part of 'sign_up_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

class SignUpState extends Equatable {
  const SignUpState({
    this.name = const Name.pure(),
    this.phoneNumber = const PhoneNumber.pure(),
    this.status = FormzStatus.pure,
  });

  final PhoneNumber phoneNumber;
  final Name name;
  final FormzStatus status;

  @override
  List<Object> get props => [name, phoneNumber, status];

  SignUpState copyWith({
    Name? name,
    PhoneNumber? phoneNumber,
    FormzStatus? status,
  }) {
    return SignUpState(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
    );
  }
}

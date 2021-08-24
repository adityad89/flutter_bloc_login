part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.phoneNumber = const PhoneNumber.pure(),
    this.status = FormzStatus.pure,
  });

  final PhoneNumber phoneNumber;
  final FormzStatus status;

  @override
  List<Object> get props => [phoneNumber, status];

  LoginState copyWith({
    PhoneNumber? phoneNumber,
    FormzStatus? status,
  }) {
    return LoginState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
    );
  }
}

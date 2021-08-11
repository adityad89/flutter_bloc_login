part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.phoneNumber = const PhoneNumber.pure(),
    this.status = FormzStatus.pure,
  });

  final Email email;
  final Password password;
  final PhoneNumber phoneNumber;
  final FormzStatus status;

  @override
  List<Object> get props => [email, password, phoneNumber, status];

  LoginState copyWith({
    Email? email,
    Password? password,
    PhoneNumber? phoneNumber,
    FormzStatus? status,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
    );
  }
}

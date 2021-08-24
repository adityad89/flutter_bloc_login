part of 'app_bloc.dart';

enum AppStatus { authenticated, unauthenticated, verification }

class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = User.empty,
    this.verificationId = "",
  });

  const AppState.authenticated(User user)
      : this._(status: AppStatus.authenticated, user: user);

  const AppState.otpVerification(String verificationId)
      : this._(status: AppStatus.verification, verificationId: verificationId);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final AppStatus status;
  final User user;
  final String verificationId;

  @override
  List<Object> get props => [status, user];
}

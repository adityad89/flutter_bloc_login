part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppLogoutRequested extends AppEvent {}

class VerificationIdChanged extends AppEvent {
  @visibleForTesting
  const VerificationIdChanged(this.verificationId);

  final String verificationId;

  @override
  List<Object> get props => [verificationId];
}

class AppUserChanged extends AppEvent {
  @visibleForTesting
  const AppUserChanged(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

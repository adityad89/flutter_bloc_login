import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_login/authentication_repository.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          authenticationRepository.currentUser.isNotEmpty
              ? AppState.authenticated(authenticationRepository.currentUser)
              : const AppState.unauthenticated(),
        ) {
    _userSubscription = _authenticationRepository.user.listen(_onUserChanged);
    _verificationIdSubscription = _authenticationRepository.verificationId
        .listen(_onverificationIdChanged);
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;
  late final StreamSubscription<String> _verificationIdSubscription;

  void _onUserChanged(User user) => add(AppUserChanged(user));

  void _onverificationIdChanged(String verificationId) =>
      add(VerificationIdChanged(verificationId));

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppUserChanged) {
      yield _mapUserChangedToState(event, state);
    } else if (event is AppLogoutRequested) {
      unawaited(_authenticationRepository.logOut());
    } else if (event is VerificationIdChanged) {
      yield _mapVerificationIdChangedToState(event, state);
    }
  }

  AppState _mapUserChangedToState(AppUserChanged event, AppState state) {
    return event.user.isNotEmpty
        ? AppState.authenticated(event.user)
        : const AppState.unauthenticated();
  }

  AppState _mapVerificationIdChangedToState(
      VerificationIdChanged event, AppState state) {
    return event.verificationId.isNotEmpty
        ? AppState.otpVerification(event.verificationId)
        : const AppState.unauthenticated();
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    _verificationIdSubscription.cancel();
    return super.close();
  }
}

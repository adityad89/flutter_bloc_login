import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_login/authentication_repository.dart';
import 'package:flutter_bloc_login/form_inputs.dart';
import 'package:formz/formz.dart';

part 'otpVerify_state.dart';

class OtpVerifyCubit extends Cubit<OtpVerifyState> {
  OtpVerifyCubit(this._authenticationRepository)
      : super(const OtpVerifyState());

  final AuthenticationRepository _authenticationRepository;

  void otpChanged(String value) {
    final smsCode = OtpCode.dirty(value);
    emit(state.copyWith(
      smsCode: smsCode,
      status: Formz.validate([smsCode]),
    ));
  }

  Future<void> logInWithOtp(String verificationId) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.logInWithOtp(
          verificationId: verificationId, smsCode: state.smsCode.value);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}

part of 'otpVerify_cubit.dart';

class OtpVerifyState extends Equatable {
  const OtpVerifyState({
    this.smsCode = const OtpCode.pure(),
    this.status = FormzStatus.pure,
  });

  final OtpCode smsCode;
  final FormzStatus status;

  @override
  List<Object> get props => [smsCode, status];

  OtpVerifyState copyWith({
    OtpCode? smsCode,
    FormzStatus? status,
  }) {
    return OtpVerifyState(
      smsCode: smsCode ?? this.smsCode,
      status: status ?? this.status,
    );
  }
}

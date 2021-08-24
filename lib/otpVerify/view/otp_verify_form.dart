import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_login/app/app.dart';
import 'package:flutter_bloc_login/otpVerify/otp_verify.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:formz/formz.dart';

class OtpVerifyForm extends StatelessWidget {
  const OtpVerifyForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpVerifyCubit, OtpVerifyState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SmsCode(),
              const SizedBox(height: 8.0),
              _ContinueButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmsCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtpVerifyCubit, OtpVerifyState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
            child: PinCodeTextField(
              appContext: context,
              length: 6,
              onChanged: (smsCode) =>
                  context.read<OtpVerifyCubit>().otpChanged(smsCode),
            ));
      },
    );
  }
}

class _ContinueButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final verificationId =
        context.select((AppBloc bloc) => bloc.state.verificationId);
    return BlocBuilder<OtpVerifyCubit, OtpVerifyState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  primary: const Color(0xFFFFD600),
                ),
                onPressed: state.status.isValidated
                    ? () => context
                        .read<OtpVerifyCubit>()
                        .logInWithOtp(verificationId)
                    : null,
                child: const Text('LOGIN'),
              );
      },
    );
  }
}

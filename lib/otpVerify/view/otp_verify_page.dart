import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_login/authentication_repository.dart';
import 'package:flutter_bloc_login/otpVerify/cubit/otpVerify_cubit.dart';
import 'package:flutter_bloc_login/otpVerify/otp_verify.dart';

class OtpVerifyPage extends StatelessWidget {
  const OtpVerifyPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: OtpVerifyPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Otp Verification')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) =>
              OtpVerifyCubit(context.read<AuthenticationRepository>()),
          child: const OtpVerifyForm(),
        ),
      ),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_login/app/app.dart';
import 'package:flutter_bloc_login/home/home.dart';
import 'package:flutter_bloc_login/login/login.dart';
import 'package:flutter_bloc_login/otpVerify/otp_verify.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.verification:
      return [OtpVerifyPage.page()];
    case AppStatus.unauthenticated:
    default:
      return [LoginPage.page()];
  }
}

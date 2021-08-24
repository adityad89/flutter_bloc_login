import 'package:formz/formz.dart';

enum OtpCodeValidationError { invalid }

class OtpCode extends FormzInput<String, OtpCodeValidationError> {
  const OtpCode.pure() : super.pure('');
  const OtpCode.dirty([String value = '']) : super.dirty(value);

  // static final RegExp _phoneNumberRegExp = RegExp(
  //   r'^(?:[+0]9)?[0-9]{10}$',
  // );

  @override
  OtpCodeValidationError? validator(String? value) {
    return null;
  }
}

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class USCodePhoneNumberMask {
  final MaskTextInputFormatter formatter;
  final FormFieldValidator<String> validator;
  final String hint;

  USCodePhoneNumberMask({@required this.formatter, this.validator, this.hint});
}

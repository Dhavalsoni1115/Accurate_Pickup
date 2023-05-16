import 'package:accurate_laboratory/constants.dart';
import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final String labelName;
  final bool obscureText;
  final dynamic onChange, validator, suffixIcon;
  const CommonTextField({
    Key? key,
    required this.labelName,
    required this.onChange,
    required this.validator,
    required this.obscureText,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
          label: Text(labelName),
          suffixIcon: suffixIcon,
          suffixIconColor: primaryColor,
          border: InputBorder.none),
      onChanged: onChange,
      validator: validator,
    );
  }
}

import 'package:flutter/material.dart';

class CustomTextFormFields extends StatelessWidget {
  final TextEditingController controler;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChange;
  final Color? colors;

  const CustomTextFormFields(
      {super.key, 
      required this.controler,
      this.onChange,
      this.prefixIcon,
      this.validator,
      this.colors});

  @override
  Widget build(BuildContext context) {
    return TextFormField();
  }
}

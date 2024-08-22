import 'package:flutter/material.dart';
import 'package:movie/presentation/constants/color.dart';
class CustomTextFormField extends StatefulWidget{
  final bool readOnly;
  final Function(String)? onChanged;
  final TextEditingController controller;
  final TextStyle? hintstyle;
  final String? errorText;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final TextStyle? errorStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  // ignore: prefer_typing_uninitialized_variables
  final type;
  final TextStyle? style;
  // ignore: prefer_typing_uninitialized_variables
  final maxlines;
  const CustomTextFormField({
    this.onChanged,
    super.key,
    this.hintstyle,
    this.errorStyle,
    this.readOnly = false,
    this.style,
    required this.controller,
    this.maxlines = 1,
    this.type = TextInputType.text,
    required this.hintText,
    this.obscureText = false,
    this.validator,
    this.enabledBorder,
    this.focusedBorder,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      readOnly: widget.readOnly,
      style: widget.style ??
          Theme.of(context).textTheme.bodySmall?.copyWith(color: MyColor().white),
      maxLines: widget.maxlines,
      keyboardType: widget.type,
      controller: widget.controller,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
        errorStyle:  TextStyle(color: MyColor().red),
        hintStyle:  TextStyle(color: MyColor().gray),
        hintText: widget.hintText,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: _hasError
                    ?MyColor().red
                    : MyColor().primarycolor) // Modify this line
            ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color:
                    _hasError ? Colors.red : Colors.white) // Modify this line
            ),
        errorBorder: OutlineInputBorder(
            // Add this
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(
            // Add this
            borderRadius: BorderRadius.circular(12),
            borderSide:const BorderSide(color: Colors.red)),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : widget.suffixIcon,
        errorText: _hasError ? widget.errorText : null, // Add this line
      ),
      obscureText: widget.obscureText && _obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          setState(() {
            _hasError = true;
          });
          return widget.errorText ?? 'This field is required';
        }
        setState(() {
          _hasError = false;
        });
        return widget.validator != null ? widget.validator!(value) : null;
      },
      onChanged: (_) {
        if (_hasError) {
          setState(() {
            _hasError = false;
          });
        }
      },
    );
  }
}

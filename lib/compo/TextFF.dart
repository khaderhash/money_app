import 'package:flutter/material.dart';
import '../constants.dart';

class textformfieldclass extends StatelessWidget {
  textformfieldclass(
      {super.key,
      this.obscureTe = false,
      required this.hinttext,
      this.onchange,
      this.suffixIcon,
      this.errorText});
  String hinttext;
  bool? obscureTe;
  Function(String)? onchange;
  final Widget? suffixIcon; // إضافة خاصية suffixIcon
  final String? errorText; // إضافة خاصية errorText لعرض رسالة الخطأ

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureTe!,
      validator: (value) {
        if (value!.isEmpty) {
          return 'field';
        }
      },
      onChanged: onchange,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hinttext,
        hintStyle: TextStyle(color: kPrimarycolor, fontSize: 16),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: kPrimarycolor)),
        border:
            OutlineInputBorder(borderSide: BorderSide(color: kPrimarycolor)),
        suffixIcon: suffixIcon,
        errorText: errorText, // عرض رسالة الخطأ هنا
      ),
    );
  }
}

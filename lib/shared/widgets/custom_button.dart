import 'package:flutter/material.dart';
import 'package:loan_manager/styles/colors.dart';
import 'package:loan_manager/styles/themes.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key, this.text = 'Continue', this.width, required this.onPressed});

  final String text;
  final double? width;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
          fixedSize: MaterialStateProperty.resolveWith(
              (states) => Size(width ?? MediaQuery.of(context).size.width, 0)),
          backgroundColor:
              MaterialStateProperty.resolveWith((states) => primaryColor)),
      child: Text(
        text,
        style: AppTheme.titleStyle(color: whiteColor),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:loan_manager/styles/app_text_style.dart';
import 'package:loan_manager/styles/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.text = 'Continue',
    this.width,
    required this.onPressed,
    this.buttonColor,
    this.textColor,
  });

  final String text;
  final Color? buttonColor;
  final Color? textColor;
  final double? width;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.resolveWith(
            (states) => Size(width ?? MediaQuery.of(context).size.width, 0)),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => buttonColor ?? primaryColor,
        ),
      ),
      child: Text(
        text,
        style: AppTextStyle.titleStyle(color: textColor ?? whiteColor),
      ),
    );
  }
}

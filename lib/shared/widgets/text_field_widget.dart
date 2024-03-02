import 'package:flutter/material.dart';
import 'package:loan_manager/styles/colors.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.isObsure,
    this.iconData,
    this.onTap,
  });

  final TextEditingController controller;
  final String hintText;
  final bool? isObsure;
  final IconData? iconData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: greyColor,
        ),
      ),
      child: TextField(
        obscureText: isObsure!,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          suffixIcon: IconButton(
            icon: Icon(iconData),
            onPressed: onTap,
          ),
        ),
      ),
    );
  }
}

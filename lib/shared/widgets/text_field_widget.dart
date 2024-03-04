import 'package:flutter/material.dart';
import 'package:loan_manager/styles/colors.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.controller,
    this.hintText,
    this.isObsure,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.labelText,
    this.prefixIcon,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final bool? isObsure;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

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
        obscureText: isObsure ?? false,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          suffixIcon: IconButton(
            icon: Icon(suffixIcon),
            onPressed: onTap,
          ),
        ),
      ),
    );
  }
}

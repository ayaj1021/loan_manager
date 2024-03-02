import 'package:flutter/material.dart';
import 'package:loan_manager/config/extension.dart';
import 'package:loan_manager/styles/app_text_style.dart';
import 'package:loan_manager/styles/colors.dart';

class LoanViewDetailsCard extends StatelessWidget {
  const LoanViewDetailsCard(
      {super.key, required this.headerText, required this.titleText});
  final String headerText;
  final String titleText;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFF4F4F4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headerText,
            style: AppTextStyle.subTitleStyle(color: primaryColor).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          8.height(),
          Text(
            titleText,
            style: AppTextStyle.subTitleStyle(color: const Color(0xFF001A4D)),
          ),
        ],
      ),
    );
  }
}

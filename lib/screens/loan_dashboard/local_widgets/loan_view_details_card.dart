import 'package:flutter/material.dart';
import 'package:loan_manager/config/extension.dart';
import 'package:loan_manager/styles/themes.dart';

class LoanViewDetailsCard extends StatelessWidget {
  const LoanViewDetailsCard(
      {super.key, required this.headerText, required this.titleText});
  final String headerText;
  final String titleText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headerText,
          style: AppTheme.headerStyle(),
        ),
        8.height(),
        Text(
          titleText,
          style: AppTheme.titleStyle(),
        ),
        25.height(),
      ],
    );
  }
}

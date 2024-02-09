import 'package:flutter/material.dart';
import 'package:loan_manager/styles/colors.dart';

Future<DateTime?> pickDate(BuildContext context,
    {required DateTime firstDate, required DateTime secondDate}) async {
  final date = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: secondDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData().copyWith(
              primaryColor: primaryColor,
              colorScheme: const ColorScheme.light(primary: primaryColor),
              buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              )),
          child: child!,
        );
      });
  return date;
}

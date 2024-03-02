import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_manager/config/extension.dart';
import 'package:loan_manager/enums/enums.dart';
import 'package:loan_manager/model/loan_model.dart';
import 'package:loan_manager/shared/utils/currency_formatter.dart';
import 'package:loan_manager/styles/colors.dart';
import 'package:loan_manager/styles/themes.dart';

class LoanInfoCard extends StatelessWidget {
  const LoanInfoCard({super.key, required this.loanData, required this.onTap});
  final LoanModel loanData;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 220,
        width: 150,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: primaryColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.outbond,
                  color: loanData.loanType == LoanType.LoanGivenByMe.name
                      ? redColor
                      : greenColor,
                ),
                Expanded(
                  child: Text(
                    "${loanData.loanCurrency.symbol}${currencyFormatter(double.parse(loanData.loanAmount.toString()))}",
                    textAlign: TextAlign.right,
                    style: AppTheme.subTitleStyle(),
                  ),
                )
              ],
            ),
            //  const Spacer(),
            10.height(),
            Text(
              loanData.loanName.ellipsis(),
              style: AppTheme.titleStyle(isBold: true),
            ),
            Text(loanData.loanType == LoanType.LoanGivenByMe.name
                ? 'Loaned to'
                : 'Borrowed from'),
            Text(
              loanData.fullName.ellipsis(),
              style: AppTheme.titleStyle(isBold: true),
            ),
            const Text('On'),
            Text(
              DateFormat.yMEd().format(loanData.loanDateIncurred),
              style: AppTheme.titleStyle(isBold: true),
            )
          ],
        ),
      ),
    );
  }
}

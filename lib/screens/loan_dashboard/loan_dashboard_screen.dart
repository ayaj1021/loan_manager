import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_manager/config/extension.dart';
import 'package:loan_manager/enums/enums.dart';
import 'package:loan_manager/provider/authentication/auth_provider.dart';
import 'package:loan_manager/provider/loan/loan_provider.dart';
import 'package:loan_manager/screens/loan_dashboard/local_widgets/loan_info_card.dart';
import 'package:loan_manager/shared/utils/currency_formatter.dart';
import 'package:loan_manager/shared/widgets/busy_overlay.dart';
import 'package:loan_manager/styles/colors.dart';
import 'package:loan_manager/styles/themes.dart';
import 'package:provider/provider.dart';

class LoanDashBoardScreen extends StatefulWidget {
  const LoanDashBoardScreen({super.key});

  @override
  State<LoanDashBoardScreen> createState() => _LoanDashBoardScreenState();
}

class _LoanDashBoardScreenState extends State<LoanDashBoardScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<LoanProviderImpl>(context, listen: false).viewLoan();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LoanProviderImpl, AuthenticationProviderImpl>(
        builder: (context, stateModel, authModel, _) {
      final totalLoaned = stateModel.loans
          .where((element) => element.loanType == LoanType.LoanGivenByMe.name)
          .fold(
              0.0,
              ((previousValue, element) =>
                  previousValue + double.parse(element.loanAmount)));
                        final totalOwed = stateModel.loans
          .where((element) => element.loanType == LoanType.LoanOwedByMe.name)
          .fold(
              0.0,
              ((previousValue, element) =>
                  previousValue + double.parse(element.loanAmount)));
      return BusyOverlay(
        show: stateModel.viewState == ViewState.Busy,
        title: stateModel.message,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Loan',
              style: AppTheme.headerStyle(),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    authModel.logOutUser().then((value) => context.go('/'));
                  },
                  icon: const Icon(Icons.exit_to_app)),
              IconButton(
                  onPressed: () {
                    context.push('/search_loan_screen');
                  },
                  icon: const Icon(Icons.search)),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: greyColor,
                        )),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Total Loaned',
                                        style: AppTheme.headerStyle(),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.outbond,
                                      color: redColor,
                                    )
                                  ],
                                ),
                                Text(
                                  '\$ ${currencyFormatter(totalLoaned)}',
                                  style: AppTheme.titleStyle(),
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Total Owed',
                                        style: AppTheme.headerStyle(),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.outbond,
                                      color: greenColor,
                                    )
                                  ],
                                ),
                                Text(
                                  '\$ ${currencyFormatter(totalOwed)}',
                                  style: AppTheme.titleStyle(),
                                ),
                              ],
                            ),
                          ),
                          const VerticalDivider(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total Balance',
                                style: AppTheme.headerStyle(),
                              ),
                              Text(
                               '\$ ${currencyFormatter(totalOwed - totalLoaned)}',
                                style: AppTheme.titleStyle(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  30.height(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pending Loan',
                        style: AppTheme.headerStyle(),
                      ),
                      15.height(),
                      (stateModel.pendingLoans.isNotEmpty)
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  stateModel.pendingLoans.length,
                                  (index) {
                                    final data = stateModel.pendingLoans[index];
                                    return LoanInfoCard(
                                      loanData: data,
                                      onTap: () {
                                        context.push(
                                            '/view_loan_screen?loan_id=${data.loanId}');
                                      },
                                    );
                                  },
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                'No Pending Loans',
                                style: AppTheme.headerStyle(),
                              ),
                            )
                    ],
                  ),
                  30.height(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Completed Loan',
                        style: AppTheme.headerStyle(),
                      ),
                      15.height(),
                      (stateModel.completedLoans.isNotEmpty)
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  stateModel.completedLoans.length,
                                  (index) {
                                    final data =
                                        stateModel.completedLoans[index];
                                    return LoanInfoCard(
                                      loanData: data,
                                      onTap: () {
                                        context.push(
                                            '/view_loan_screen?loan_id=${data.loanId}');
                                      },
                                    );
                                  },
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                'No Completed Loans',
                                style: AppTheme.headerStyle(),
                              ),
                            )
                    ],
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
              backgroundColor: primaryColor,
              onPressed: () {
                context.push('/add_loan_screen');
              },
              label: const Text('Create new loan')),
        ),
      );
    });
  }
}

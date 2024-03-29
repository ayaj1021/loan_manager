import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loan_manager/config/extension.dart';
import 'package:loan_manager/enums/enums.dart';
import 'package:loan_manager/provider/loan/loan_provider.dart';
import 'package:loan_manager/screens/pages/loan_dashboard/local_widgets/loan_view_details_card.dart';
import 'package:loan_manager/shared/utils/app_logger.dart';
import 'package:loan_manager/shared/utils/currency_formatter.dart';
import 'package:loan_manager/shared/utils/show_message.dart';
import 'package:loan_manager/shared/utils/url_launcher_helper.dart';
import 'package:loan_manager/shared/widgets/busy_overlay.dart';
import 'package:loan_manager/shared/widgets/custom_button.dart';
import 'package:loan_manager/styles/app_text_style.dart';
import 'package:loan_manager/styles/colors.dart';
import 'package:provider/provider.dart';

class ViewLoanScreen extends StatefulWidget {
  const ViewLoanScreen({super.key, required this.loanId});
  final String loanId;

  @override
  State<ViewLoanScreen> createState() => _ViewLoanScreenState();
}

class _ViewLoanScreenState extends State<ViewLoanScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<LoanProviderImpl>(context, listen: false)
        .viewLoanById(widget.loanId);
  }

  @override
  Widget build(BuildContext context) {
    appLogger(widget.loanId);
    return Consumer<LoanProviderImpl>(builder: (context, stateModel, _) {
      return BusyOverlay(
        show: stateModel.viewState == ViewState.Busy,
        title: stateModel.message,
        child: Scaffold(
          backgroundColor: const Color(0xFFEFF1F5),
          appBar: AppBar(
            title: Text(
              'Loan Details',
              style: AppTextStyle.headerStyle(),
            ),
          ),
          body: stateModel.singleLoan == null
              ? const SizedBox()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFFFFF),
                      ),
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LoanViewDetailsCard(
                              titleText: stateModel.singleLoan!.loanName,
                              headerText: 'Loan Name'),
                          10.height(),
                          LoanViewDetailsCard(
                              titleText:
                                  "${stateModel.singleLoan!.loanCurrency.symbol}${currencyFormatter(
                                double.parse(
                                  stateModel.singleLoan!.loanAmount.toString(),
                                ),
                              )}",
                              headerText: 'Loan Amount'),
                          if (stateModel.singleLoan!.loanDoc != null)
                            Column(
                              children: [
                                Text(
                                  'Loan Document',
                                  style: AppTextStyle.headerStyle(),
                                ),
                                TextButton(
                                    onPressed: () {
                                      launchSite(
                                          stateModel.singleLoan!.loanDoc);
                                    },
                                    child: Text(
                                      'View Document',
                                      style: AppTextStyle.titleStyle(
                                          color: primaryColor),
                                    ))
                              ],
                            ),
                          10.height(),
                          Column(
                            children: [
                              LoanViewDetailsCard(
                                  titleText: DateFormat.yMEd().format(
                                      stateModel.singleLoan!.loanDateIncurred),
                                  headerText: 'Incurred Date'),
                              10.height(),
                              LoanViewDetailsCard(
                                  titleText: DateFormat.yMEd().format(
                                      stateModel.singleLoan!.loanDateDue),
                                  headerText: 'Due Date'),
                            ],
                          ),
                          10.height(),
                          const Divider(),
                          10.height(),
                          Text(
                            stateModel.selectedLoanType == LoanType.LoanOwedByMe
                                ? "Debtor's Details"
                                : "Creditor's Details",
                            style:
                                AppTextStyle.headerStyle(color: primaryColor),
                          ),
                          const Divider(),
                          10.height(),
                          LoanViewDetailsCard(
                              titleText: stateModel.singleLoan!.fullName,
                              headerText: 'Full Name'),
                          10.height(),
                          LoanViewDetailsCard(
                              titleText: stateModel.singleLoan!.phoneNumber,
                              headerText: 'Phone Number'),
                          20.height(),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  onPressed: () async {
                                    await stateModel.deleteLoan(widget.loanId);

                                    if (stateModel.viewState ==
                                        ViewState.Error) {
                                      if (context.mounted) {
                                        showMessage(context, stateModel.message,
                                            isError: true);
                                      }
                                      return;
                                    }

                                    if (stateModel.viewState ==
                                        ViewState.Success) {
                                      if (context.mounted) {
                                        stateModel.viewLoan();
                                        showMessage(
                                          context,
                                          stateModel.message,
                                        );
                                        context.go('/loan_dashboard_screen');
                                      }
                                    }
                                  },
                                  text: 'Delete',
                                ),
                              ),
                              if (stateModel.singleLoan!.loanStatus ==
                                  LoanStatus.Pending.name)
                                10.width(),
                              if (stateModel.singleLoan!.loanStatus ==
                                  LoanStatus.Pending.name)
                                Expanded(
                                  child: CustomButton(
                                    onPressed: () async {
                                      await stateModel
                                          .updateLoan(widget.loanId);

                                      if (stateModel.viewState ==
                                          ViewState.Error) {
                                        if (context.mounted) {
                                          showMessage(
                                              context, stateModel.message,
                                              isError: true);
                                        }
                                        return;
                                      }

                                      if (stateModel.viewState ==
                                          ViewState.Success) {
                                        if (context.mounted) {
                                          stateModel.viewLoan();
                                          showMessage(
                                            context,
                                            stateModel.message,
                                          );
                                          context.go('/loan_dashboard_screen');
                                        }
                                      }
                                    },
                                    text: 'Mark as done',
                                  ),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      );
    });
  }
}

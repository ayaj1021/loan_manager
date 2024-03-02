import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_form_field/flutter_text_form_field.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_manager/config/extension.dart';
import 'package:loan_manager/enums/enums.dart';
import 'package:loan_manager/provider/loan/loan_provider.dart';
import 'package:loan_manager/service/upload_doc_service.dart';
import 'package:loan_manager/shared/utils/pick_files.dart';
import 'package:loan_manager/shared/utils/show_message.dart';
import 'package:loan_manager/shared/widgets/busy_overlay.dart';
import 'package:loan_manager/shared/widgets/custom_button.dart';
import 'package:loan_manager/shared/widgets/date_picker.dart';
import 'package:loan_manager/styles/colors.dart';
import 'package:loan_manager/styles/themes.dart';
import 'package:provider/provider.dart';

class AddLoanScreen extends StatefulWidget {
  const AddLoanScreen({super.key});

  @override
  State<AddLoanScreen> createState() => _AddLoanScreenState();
}

class _AddLoanScreenState extends State<AddLoanScreen> {
  final currentDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProviderImpl>(builder: (context, stateModel, _) {
      return BusyOverlay(
        show: stateModel.viewState == ViewState.Busy,
        title: stateModel.message,
        child: Scaffold(
            appBar: AppBar(),
            body: SafeArea(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Loan Name',
                          style: AppTheme.headerStyle(),
                        ),
                        8.height(),
                        CustomTextField(
                          stateModel.loanNameController,
                          hint: 'Loan Name',
                          password: false,
                          border: Border.all(color: greyColor),
                        ),
                        20.height(),
                        Text(
                          'Loan Type',
                          style: AppTheme.headerStyle(),
                        ),
                        8.height(),
                        ...List.generate(LoanType.values.length, (index) {
                          final type = LoanType.values[index];
                          final loanText = type == LoanType.LoanGivenByMe
                              ? 'Giving out a loan'
                              : 'Taking a loan';
                          return RadioListTile(
                            value: type,
                            contentPadding: const EdgeInsets.all(0),
                            groupValue: stateModel.selectedLoanType,
                            activeColor: primaryColor,
                            title: Text(loanText),
                            onChanged: (value) {
                              stateModel.selectedLoanType = value;
                            },
                          );
                        }),
                        20.height(),
                        Text(
                          'Loan Document (Optional)',
                          style: AppTheme.headerStyle(),
                        ),
                        8.height(),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                pickDocument().then((value) async {
                                  if (value != null) {
                                    //Upload

                                    stateModel.viewState = ViewState.Busy;
                                    stateModel.message =
                                        'Uploading document...';
                                    final result =
                                        await uploadDocumentToServer(value);

                                    if (result.state == ViewState.Error) {
                                      if (context.mounted) {
                                        showMessage(context, result.fileUrl);
                                      }

                                      stateModel.viewState == ViewState.Error;
                                      return;
                                    }

                                    if (result.state == ViewState.Success) {
                                      stateModel.uploadedDocument =
                                          result.fileUrl;
                                      if (context.mounted) {
                                        // showMessage(context, result.fileUrl);
                                        showMessage(context,
                                            "Document uploaded successfully");
                                      }

                                      stateModel.viewState == ViewState.Success;
                                      return;
                                    }
                                  }
                                });
                              },
                              child: Text(
                                'Upload Document (pdf, image)',
                                style: AppTheme.titleStyle(color: primaryColor),
                              ),
                            ),
                            const Spacer(),
                            if (stateModel.uploadedDocument != null)
                              const Icon(
                                Icons.check_circle,
                                color: greenColor,
                              )
                          ],
                        ),
                        20.height(),
                        Row(
                          children: [
                            Text(
                              'Loan Amount',
                              style: AppTheme.headerStyle(),
                            ),
                            const Spacer(),
                            Text(
                              'Loan Currency',
                              style: AppTheme.headerStyle(),
                            ),
                          ],
                        ),
                        8.height(),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                stateModel.loanAmountController,
                                hint: 'Loan Amount',
                                keyboardType: TextInputType.number,
                                password: false,
                                border: Border.all(color: greyColor),
                              ),
                            ),
                            30.width(),
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                showCurrencyPicker(
                                  context: context,
                                  onSelect: (Currency value) {
                                    stateModel.selectedCurrency = value;
                                  },
                                  showCurrencyCode: true,
                                  showCurrencyName: true,
                                );
                              },
                              child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: greyColor),
                                    color: whiteColor,
                                  ),
                                  child: Text(stateModel.selectedCurrency ==
                                          null
                                      ? 'Currency'
                                      : '${stateModel.selectedCurrency!.code} - ${stateModel.selectedCurrency!.symbol}')),
                            ))
                          ],
                        ),
                        20.height(),
                        Row(
                          children: [
                            Text(
                              'Incurred Date',
                              style: AppTheme.headerStyle(),
                            ),
                            const Spacer(),
                            Text(
                              'Due Date',
                              style: AppTheme.headerStyle(),
                            ),
                          ],
                        ),
                        8.height(),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: greyColor),
                                ),
                                height: 50,
                                child: TextField(
                                  controller: stateModel.incurredDateController,
                                  onTap: () async {
                                    final date = await pickDate(context,
                                        firstDate:
                                            DateTime(currentDate.year - 1),
                                        secondDate: currentDate);
                                    if (date != null) {
                                      stateModel.incurredDateController.text =
                                          date.toString();
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Incurred Date',
                                  ),
                                  readOnly: true,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                            30.width(),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: greyColor),
                                ),
                                height: 50,
                                child: TextField(
                                  controller: stateModel.dueDateController,
                                  onTap: () async {
                                    final date = await pickDate(context,
                                        firstDate:
                                            DateTime(currentDate.year - 1),
                                        secondDate:
                                            DateTime(currentDate.year + 150));
                                    if (date != null) {
                                      stateModel.dueDateController.text =
                                          date.toString();
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Due Date',
                                  ),
                                  readOnly: true,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                          ],
                        ),
                        20.height(),
                        if (stateModel.selectedLoanType != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${stateModel.selectedLoanType == LoanType.LoanOwedByMe ? 'Creditor\'s' : 'Debtor\'s'} details",
                                style: AppTheme.headerStyle(),
                              ),
                              10.height(),
                              Text(
                                'Full Name',
                                style: AppTheme.headerStyle(),
                              ),
                              8.height(),
                              CustomTextField(
                                stateModel.creditorOrDebtorNameController,
                                hint: 'Full Name',
                                password: false,
                                border: Border.all(color: greyColor),
                              ),
                              10.height(),
                              Text(
                                'Phone Number',
                                style: AppTheme.headerStyle(),
                              ),
                              8.height(),
                              CustomTextField(
                                stateModel
                                    .creditorOrDebtorPhoneNumberController,
                                hint: 'Phone Number',
                                keyboardType: TextInputType.number,
                                password: false,
                                border: Border.all(color: greyColor),
                              ),
                            ],
                          ),
                        40.height(),
                        CustomButton(
                          onPressed: () async {
                            if (stateModel.loanNameController.text.isEmpty ||
                                stateModel.loanAmountController.text.isEmpty ||
                                stateModel
                                    .incurredDateController.text.isEmpty ||
                                stateModel.dueDateController.text.isEmpty) {
                              showMessage(context, "All fields are required",
                                  isError: true);
                              return;
                            }

                            if (stateModel.selectedLoanType == null) {
                              showMessage(context, "Please select a loan type",
                                  isError: true);
                              return;
                            }

                            if (stateModel.selectedCurrency == null) {
                              showMessage(context, "Please select a currency",
                                  isError: true);
                              return;
                            }
                            if (stateModel.creditorOrDebtorNameController.text
                                    .isEmpty ||
                                stateModel.creditorOrDebtorPhoneNumberController
                                    .text.isEmpty) {
                              final messageType = stateModel.selectedLoanType ==
                                      LoanType.LoanGivenByMe
                                  ? "Debtor's details are required"
                                  : "Creditor's details are required";
                              showMessage(context, messageType, isError: true);
                              return;
                            }

                            await stateModel.addLoan();
                            if (stateModel.viewState == ViewState.Error) {
                              if (context.mounted) {
                                showMessage(context, stateModel.message,
                                    isError: true);
                              }

                              return;
                            }

                            if (stateModel.viewState == ViewState.Success) {
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
                          text: 'Send Request',
                        ),
                        40.height(),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_manager/config/extension.dart';
import 'package:loan_manager/enums/enums.dart';
import 'package:loan_manager/provider/loan/loan_provider.dart';
import 'package:loan_manager/screens/pages/loan_dashboard/local_widgets/loan_info_card.dart';
import 'package:loan_manager/shared/widgets/busy_overlay.dart';
import 'package:loan_manager/styles/colors.dart';
import 'package:loan_manager/styles/themes.dart';
import 'package:provider/provider.dart';

class SearchLoanScreen extends StatefulWidget {
  const SearchLoanScreen({super.key});

  @override
  State<SearchLoanScreen> createState() => _SearchLoanScreenState();
}

class _SearchLoanScreenState extends State<SearchLoanScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProviderImpl>(builder: (context, stateModel, _) {
      return BusyOverlay(
        show: stateModel.viewState == ViewState.Busy,
        title: stateModel.message,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Search Loan',
              style: AppTheme.headerStyle(),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: primaryColor),
                  ),
                  child: TextField(
                    controller: stateModel.searchLoanQueryController,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        stateModel.searchLoan();
                      }
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter loan name',
                      // border: Border.all(color: greyColor),
                    ),
                  ),
                ),
                20.height(),
                if (stateModel.searchedLoan == null)
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 50),
                      child: Text(
                        '${stateModel.searchedLoan == null ? "Search for a loan" : stateModel.searchLoanQueryController}',
                        style: AppTheme.headerStyle(color: primaryColor),
                      )),
                if (stateModel.searchedLoan != null &&
                    stateModel.searchedLoan!.isEmpty)
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 50),
                      child: Text(
                        "No loan found",
                        style: AppTheme.headerStyle(color: primaryColor),
                      )),
                if (stateModel.searchedLoan != null &&
                    stateModel.searchedLoan!.isNotEmpty)
                  Expanded(
                    child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      children: List.generate(stateModel.searchedLoan!.length,
                          (index) {
                        final data = stateModel.searchedLoan![index];
                        return LoanInfoCard(
                          loanData: data,
                          onTap: () {
                            context.push(
                                '/view_loan_screen?loan_id=${data.loanId}');
                          },
                        );
                      }),
                    ),
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}

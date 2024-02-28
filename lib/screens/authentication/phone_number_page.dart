import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_manager/config/extension.dart';
import 'package:loan_manager/enums/enums.dart';
import 'package:loan_manager/provider/authentication/auth_provider.dart';
import 'package:loan_manager/shared/utils/show_message.dart';
import 'package:loan_manager/shared/widgets/busy_overlay.dart';
import 'package:loan_manager/shared/widgets/custom_button.dart';
import 'package:loan_manager/styles/colors.dart';
import 'package:loan_manager/styles/themes.dart';
import 'package:provider/provider.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({super.key});

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  Country selectedCountry = Country(
      phoneCode: "234",
      countryCode: "NG",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "Nigeria",
      example: "Nigeria",
      displayName: "Nigeria",
      displayNameNoCountryCode: "NG",
      e164Key: "");

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProviderImpl>(
        builder: (context, stateModel, _) {
      return BusyOverlay(
        show: stateModel.state == ViewState.Busy,
        title: stateModel.message,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
            ),
            title: Text(
              'Phone Number',
              style: AppTheme.titleStyle(),
            ),
          ),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Please add your phone number',
                    style: AppTheme.subTitleStyle().copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                30.height(),
                Text(
                  '* Phone number',
                  style: AppTheme.subTitleStyle(),
                ),
                15.height(),

                Container(
                    height: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: greyColor,
                      ),
                    ),
                    child: TextField(
                      cursorColor: primaryColor,
                      controller: stateModel.phoneController,
                      style: AppTheme.titleStyle(),
                      onChanged: (value) {
                        setState(() {
                          stateModel.phoneController.text = value;
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(3),
                          border: InputBorder.none,
                          hintText: "Enter your phone number",
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(8),
                            child: InkWell(
                              onTap: () {
                                showCountryPicker(
                                    context: context,
                                    countryListTheme:
                                        const CountryListThemeData(
                                      bottomSheetHeight: 550,
                                    ),
                                    onSelect: (value) {
                                      setState(() {
                                        selectedCountry = value;
                                      });
                                    });
                              },
                              child: Text(
                                '${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}',
                                style: AppTheme.titleStyle(),
                              ),
                            ),
                          ),
                          suffixIcon:
                              stateModel.phoneController.text.length >= 9
                                  ? Container(
                                      height: 30,
                                      width: 30,
                                      margin: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: primaryColor,
                                      ),
                                      child: const Icon(
                                        Icons.done,
                                        color: whiteColor,
                                        size: 20,
                                      ),
                                    )
                                  : null),
                    )),
                50.height(),
                CustomButton(
                  onPressed: () async {
                    if (stateModel.phoneController.text.isEmpty) {
                      showMessage(
                        context,
                        'Please enter your phone number',
                        isError: true,
                      );
                      return;
                    }
                    await stateModel.registerUserWithPhoneNumber(context,
                        "+${selectedCountry.phoneCode}${stateModel.phoneController.text.trim()}");

                    // To avoid Buildcontext message
                    if (stateModel.state == ViewState.Error &&
                        context.mounted) {
                      showMessage(context, stateModel.message);
                      return;
                    }
                    if (stateModel.state == ViewState.Success &&
                        context.mounted) {
                      showMessage(context, stateModel.message);
                      stateModel.isCodeSent == true
                          ? context.push(
                              '/verification_page${stateModel.phoneController}${stateModel.verificationId}',
                            )
                          : null;
                      // context.go('/loan_dashboard_screen');
                    }
                  },
                  text: 'Sign up',
                )

                // CustomTextField(
                //   stateModel.phoneController,
                //   password: false,
                //   hint: 'Enter Phone Number',
                //   keyboardType: TextInputType.phone,
                // )
              ],
            ),
          )),
        ),
      );
    });
  }
}

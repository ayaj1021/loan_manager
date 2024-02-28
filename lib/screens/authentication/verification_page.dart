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
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage(
      {super.key, required this.phoneNumber, required this.verificationId});
  final String phoneNumber;
  final String verificationId;
  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  String? otpCode;
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
              'Enter OTP',
              style: AppTheme.titleStyle(),
            ),
          ),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: Image.asset(
                      'assets/images/phone_image.png',
                    ),
                  ),
                  30.height(),
                  Text(
                    'Please kindly inout the OTP code we have sent to ${stateModel.phoneController.text}',
                    style: AppTheme.titleStyle(),
                  ),
                  20.height(),
                  Pinput(
                    length: 6,
                    showCursor: true,
                    defaultPinTheme: PinTheme(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: primaryColor,
                            )),
                        textStyle: AppTheme.titleStyle()),
                    onCompleted: (value) {
                      setState(() {
                        otpCode = value;
                      });
                      print(otpCode);
                    },
                  ),
                  50.height(),
                  CustomButton(
                    onPressed: () {
                      if (otpCode != null) {
                        verifyOtp(context, otpCode!);
                      } else {
                        showMessage(context, 'Enter 6-Digit code');
                      }
                    },
                    text: 'Submit code',
                  ),
                  20.height(),
                  Text(
                    'Didn\'t receive any code?',
                    style: AppTheme.titleStyle(),
                  ),
                  5.height(),
                  Text(
                    'Resend New Code',
                    style:
                        AppTheme.titleStyle(color: primaryColor, isBold: true),
                  )
                ],
              ),
            ),
          )),
        ),
      );
    });
  }

  void verifyOtp(BuildContext context, String userOtp) {
    final ap = Provider.of<AuthenticationProviderImpl>(context, listen: false);
    ap.verifyOtp(context, widget.verificationId, userOtp, () {
      ap.checkExistingUser().then((value) async {
        context.go('/loan_dashboard_screen');
        // if (value == true) {
        // } else {
        //   context.go('/loan_dashboard_screen');
        // }
      });
    });
  }
}

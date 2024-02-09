import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_form_field/flutter_text_form_field.dart';
import 'package:flutter_utilities/flutter_utilities.dart';
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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProviderImpl>(
        builder: (context, stateModel, _) {
      return BusyOverlay(
        show: stateModel.state == ViewState.Busy,
        title: stateModel.message,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Register',
                      style: AppTheme.headerStyle(),
                    ),
                    120.height(),
                    CustomTextField(
                      stateModel.userNameController,
                      hint: 'Username',
                      password: false,
                      border: Border.all(color: greyColor),
                    ),
                    20.height(),
                    CustomTextField(
                      stateModel.emailController,
                      hint: 'Email',
                      password: false,
                      border: Border.all(color: greyColor),
                    ),
                    20.height(),
                    CustomTextField(
                      stateModel.passwordController,
                      hint: 'Password',
                      border: Border.all(color: greyColor),
                    ),
                    100.height(),
                    CustomButton(
                      onPressed: () async {
                        if (stateModel.userNameController.text.isEmpty ||
                            stateModel.passwordController.text.isEmpty) {
                          showMessage(context, 'All fields are required',
                              isError: true);
                          return;
                        }
                        if (!FlutterUtilities().isEmailValid(
                            stateModel.emailController.text.trim())) {
                          showMessage(context, 'Invalid mail provided',
                              isError: true);
                          return;
                        }
                        await stateModel.registerUser();
                        // To avoid Buildcontext message
                        if (stateModel.state == ViewState.Error &&
                            context.mounted) {
                          showMessage(context, stateModel.message);
                          return;
                        }

                        if (stateModel.state == ViewState.Success &&
                            context.mounted) {
                          showMessage(context, stateModel.message);
                          context.go('/loan_dashboard_screen');
                        }
                      },
                      text: 'Register',
                    ),
                    50.height(),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: 'Already have an account?  ',
                              style: AppTheme.titleStyle(isBold: true)),
                          TextSpan(
                            text: 'Sign in',
                            style: AppTheme.titleStyle(
                              isBold: true,
                              color: primaryColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.go('/login_screen');
                              },
                          ),
                        ],
                      ),
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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utilities/flutter_utilities.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_manager/config/extension.dart';
import 'package:loan_manager/enums/enums.dart';
import 'package:loan_manager/provider/authentication/auth_provider.dart';
import 'package:loan_manager/provider/theme_provider.dart';
import 'package:loan_manager/shared/utils/show_message.dart';
import 'package:loan_manager/shared/widgets/busy_overlay.dart';
import 'package:loan_manager/shared/widgets/custom_button.dart';
import 'package:loan_manager/styles/app_text_style.dart';
import 'package:loan_manager/styles/colors.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthenticationProviderImpl, ThemeProvider>(
        builder: (context, stateModel, theme, _) {
      return BusyOverlay(
        show: stateModel.state == ViewState.Busy,
        title: stateModel.message,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/loan_app_logo.png',
                      scale: 10,
                    ),
                    Text(
                      'Login',
                      style: AppTextStyle.headerStyle(),
                    ),
                    60.height(),
                    // CustomTextField(
                    //   stateModel.emailController,
                    //   hint: 'Email',
                    //   password: false,
                    //   border: Border.all(color: greyColor),
                    // ),
                    20.height(),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: greyColor,
                        ),
                      ),
                      child: TextField(
                        controller: stateModel.emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                        ),
                      ),
                    ),
                    20.height(),
                    // CustomTextField(
                    //   stateModel.passwordController,
                    //   hint: 'Password',
                    //   border: Border.all(color: greyColor),
                    // ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: greyColor,
                        ),
                      ),
                      child: TextField(
                        controller: stateModel.passwordController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                        ),
                      ),
                    ),
                    40.height(),
                    CustomButton(
                      onPressed: () async {
                        if (stateModel.passwordController.text.isEmpty) {
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
                        await stateModel.logInUser();
                        // To avoid Buildcontext message
                        if (stateModel.state == ViewState.Error &&
                            context.mounted) {
                          showMessage(context, stateModel.message);
                          return;
                        }

                        if (stateModel.state == ViewState.Success &&
                            context.mounted) {
                          showMessage(context, stateModel.message);
                          context.go('/bottom_nav_section');
                        }
                      },
                      text: 'Login',
                    ),
                    50.height(),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: 'Don\'t have an account?  ',
                              style: AppTextStyle.titleStyle(isBold: true)),
                          TextSpan(
                            text: 'Register',
                            style: AppTextStyle.titleStyle(
                              isBold: true,
                              color: primaryColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.go('/register_screen');
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

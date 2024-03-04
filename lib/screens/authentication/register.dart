import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utilities/flutter_utilities.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_manager/config/extension.dart';
import 'package:loan_manager/enums/enums.dart';
import 'package:loan_manager/provider/authentication/auth_provider.dart';
import 'package:loan_manager/provider/obscure_provider/obscure_text.dart';
import 'package:loan_manager/shared/utils/show_message.dart';
import 'package:loan_manager/shared/widgets/busy_overlay.dart';
import 'package:loan_manager/shared/widgets/custom_button.dart';
import 'package:loan_manager/shared/widgets/text_field_widget.dart';
import 'package:loan_manager/styles/app_text_style.dart';
import 'package:loan_manager/styles/colors.dart';
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
                    Image.asset(
                      'assets/images/loan_app_logo.png',
                      scale: 10,
                    ),
                    Text(
                      'Register',
                      style: AppTextStyle.headerStyle(),
                    ),
                    60.height(),
                    TextFieldWidget(
                      controller: stateModel.userNameController,
                      hintText: 'Username',
                      isObsure: false,
                    ),
                    20.height(),
                    TextFieldWidget(
                      controller: stateModel.emailController,
                      hintText: 'Email',
                      isObsure: false,
                    ),
                    20.height(),
                    Consumer<ObscureTextProvider>(
                        builder: (context, boolProvider, _) {
                      return TextFieldWidget(
                        controller: stateModel.passwordController,
                        hintText: 'Password',
                        isObsure: boolProvider.isTrue,
                        suffixIcon: boolProvider.isTrue == true
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onTap: () {
                          boolProvider.changeBool();
                        },
                      );
                    }),
                    30.height(),
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
                        await stateModel.registerUserEmailAndPassword();
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
                    10.height(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Divider(
                            color: greyColor,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Or'),
                        ),
                        Expanded(
                          child: Divider(
                            color: greyColor,
                          ),
                        ),
                      ],
                    ),
                    20.height(),
                    CustomButton(
                      buttonColor: primaryColor,
                      text: 'Sign up with phone number',
                      onPressed: () {
                        context.push('/phone_number_page');
                      },
                    ),
                    20.height(),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: 'Already have an account?  ',
                              style: AppTextStyle.titleStyle(isBold: true)),
                          TextSpan(
                            text: 'Sign in',
                            style: AppTextStyle.titleStyle(
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

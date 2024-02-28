import 'package:go_router/go_router.dart';
import 'package:loan_manager/screens/authentication/login.dart';
import 'package:loan_manager/screens/authentication/phone_number_page.dart';
import 'package:loan_manager/screens/authentication/register.dart';
import 'package:loan_manager/screens/authentication/verification_page.dart';
import 'package:loan_manager/screens/loan_dashboard/add_loan/add_loan_screen.dart';
import 'package:loan_manager/screens/loan_dashboard/loan_dashboard_screen.dart';
import 'package:loan_manager/screens/loan_dashboard/search_loan/search_loan_screen.dart';
import 'package:loan_manager/screens/loan_dashboard/view_loan/view_loan_screen.dart';
import 'package:loan_manager/screens/splash_screen.dart';

final router = GoRouter(initialLocation: '/', routes: [
  GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
  GoRoute(
      path: '/register_screen',
      builder: (context, state) => const RegisterScreen()),
  GoRoute(
      path: '/login_screen', builder: (context, state) => const LoginScreen()),
  GoRoute(
      path: '/loan_dashboard_screen',
      builder: (context, state) => const LoanDashBoardScreen()),
  GoRoute(
      path: '/add_loan_screen',
      builder: (context, state) => const AddLoanScreen()),
  GoRoute(
      path: '/view_loan_screen',
      builder: (context, state) {
        final loadId = state.uri.queryParameters['loan_id'];
        return ViewLoanScreen(
          loanId: loadId!,
        );
      }),
  GoRoute(
      path: '/search_loan_screen',
      builder: (context, state) => const SearchLoanScreen()),
  GoRoute(
      path: '/phone_number_page',
      builder: (context, state) => const PhoneNumberPage()),
  GoRoute(
      path: '/verification_page:phoneNumber:verificationId',
      builder: (context, state) {
        final phoneNumber = state.pathParameters['phoneNumber'];
        final verificationId = state.pathParameters['verificationId'];
        return VerificationPage(
          phoneNumber: phoneNumber!,
          verificationId: verificationId!,
        );
      }),
]);

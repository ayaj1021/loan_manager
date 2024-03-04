import 'package:go_router/go_router.dart';
import 'package:loan_manager/model/chat_user_model.dart';
import 'package:loan_manager/screens/authentication/login.dart';
import 'package:loan_manager/screens/authentication/phone_number_page.dart';
import 'package:loan_manager/screens/authentication/register.dart';
import 'package:loan_manager/screens/authentication/verification_page.dart';
import 'package:loan_manager/screens/bottom_nav/bottom_nav_section.dart';
import 'package:loan_manager/screens/pages/chats_section/chat_details_screen.dart';
import 'package:loan_manager/screens/pages/chats_section/chat_user_item.dart';
import 'package:loan_manager/screens/pages/loan_dashboard/add_loan/add_loan_screen.dart';
import 'package:loan_manager/screens/pages/loan_dashboard/loan_dashboard_screen.dart';
import 'package:loan_manager/screens/pages/loan_dashboard/search_loan/search_loan_screen.dart';
import 'package:loan_manager/screens/pages/loan_dashboard/view_loan/view_loan_screen.dart';
import 'package:loan_manager/screens/splash_screen.dart';

final router = GoRouter(initialLocation: '/', routes: [
  GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
  GoRoute(
      path: '/register_screen',
      builder: (context, state) => const RegisterScreen()),
  GoRoute(
      path: '/login_screen', builder: (context, state) => const LoginScreen()),
  GoRoute(
      path: '/bottom_nav_section',
      builder: (context, state) => const BottomNavSection()),
  GoRoute(
      path: '/loan_dashboard_screen',
      builder: (context, state) => const LoanDashBoardScreen()),
  GoRoute(
      path: '/loan_dashboard_screen',
      builder: (context, state) {
        ChatUserModel chatUserModel = state.extra as ChatUserModel;
        return ChatUserItem(
          chatUserModel: chatUserModel,
        );
      }),
  GoRoute(
      path: '/chat_details_screen',
      builder: (
        context,
        state,
      ) {
        ChatUserModel chatUserModel = state.extra as ChatUserModel;
        return ChatDetailsScreen(
          chatUserModel: chatUserModel,
        );
      }),
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

import 'package:flutter/material.dart';
import 'package:loan_manager/provider/bottom_nav_selection_provider/bottom_nav_selection_provider.dart';
import 'package:loan_manager/screens/pages/chats_section/chat_page.dart';
import 'package:loan_manager/screens/pages/loan_dashboard/add_loan/add_loan_screen.dart';
import 'package:loan_manager/screens/pages/loan_dashboard/loan_dashboard_screen.dart';
import 'package:loan_manager/styles/colors.dart';
import 'package:provider/provider.dart';

class BottomNavSection extends StatefulWidget {
  const BottomNavSection({super.key});

  @override
  State<BottomNavSection> createState() => _BottomNavSectionState();
}

class _BottomNavSectionState extends State<BottomNavSection> {
  final List _pages = const [
    LoanDashBoardScreen(),
    AddLoanScreen(),
    ChatPage()
  ];

  int selectedIndex = 0;

  void changeIndex(int index) {
    selectedIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavSelectionProvider>(
        builder: (context, bottomNavProv, _) {
      return Scaffold(
        body: _pages[bottomNavProv.selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            selectedItemColor: primaryColor,
            currentIndex: bottomNavProv.selectedIndex,
            onTap: bottomNavProv.changeIndex,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Loan'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.chat_outlined), label: 'Chat')
            ]),
      );
    });
  }
}

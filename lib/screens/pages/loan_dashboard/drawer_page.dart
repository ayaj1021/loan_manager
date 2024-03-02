import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_manager/provider/authentication/auth_provider.dart';
import 'package:loan_manager/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeProvider>(context);
    return Drawer(
      child: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: 120,
          ),
          children: [
            ListTile(
                // contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                leading: const Text(
                  'Change Theme',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                trailing: Switch(
                    // secondary: Icon(
                    //   themeState.getDarkTheme
                    //       ? Icons.dark_mode_outlined
                    //       : Icons.light_mode_outlined,
                    // ),
                    value: themeState.getDarkTheme,
                    onChanged: (bool value) {
                      setState(() {
                        themeState.setDarkTheme = value;
                      });
                    })
                // IconButton(
                //     onPressed: () {
                //       theme.toggleTheme();
                //     },
                //     icon: const Icon(Icons.sunny)),
                ),
            Consumer<AuthenticationProviderImpl>(
                builder: (context, authModel, _) {
              return ListTile(
                leading: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  onPressed: () {
                    authModel.logOutUser().then(
                          (value) => context.go('/'),
                        );
                  },
                  icon: const Icon(
                    Icons.exit_to_app,
                    size: 30,
                  ),
                ),
              );
            }),
          ]),
    );
  }
}

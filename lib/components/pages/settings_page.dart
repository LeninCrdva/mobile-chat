import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:simple_chat/src/service/toast_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
  late bool _isDarkMode = brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Log out'),
            onTap: () {
              _closeSession();
            },
          ),
          ListTile(
            leading: const Icon(Icons.sunny),
            title: const Text('Dark mode'),
            trailing: Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
                _toggleTheme();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _toggleTheme() {
    if (_isDarkMode) {
      // Set theme to dark
    }

    if (!_isDarkMode) {
      // Set theme to light
    }
  }

  void _closeSession() {
    ToastService().showSnackBar('Session closed');
  }
}

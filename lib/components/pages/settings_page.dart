import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:simple_chat/src/service/profile_service.dart';
import 'package:simple_chat/src/service/session_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;
  late bool _isDarkMode = brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileService>(context, listen: false).loadStorageProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileService>(context);
    return Scaffold(
      body: ListView(
        children: [
          Builder(builder: (context) {
            final user = provider.user;

            if (user == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.imageUrl),
                    maxRadius: 75,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user.username.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 15),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 50),
            leading: const Icon(Icons.lock),
            title: const Text('Log out'),
            onTap: () {
              SessionService.closeSession();
            },
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 50),
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
}

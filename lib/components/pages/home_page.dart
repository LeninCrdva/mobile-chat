import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat/components/pages/chat_list_page.dart';
import 'package:simple_chat/components/pages/settings_page.dart';
import 'package:simple_chat/main.dart';
import 'package:simple_chat/route/named_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const ChatListPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Chat'),
      ),
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            // This change with a Dialog to create a new chat
            navigatorKey.currentState!.pushNamed(NamedRoute.home);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(currentTheme),
    );
  }

  Widget _buildBottomNavigationBar(bool isLightTheme) {
    return CustomNavigationBar(
      backgroundColor: isLightTheme ? Colors.white : Colors.black,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        CustomNavigationBarItem(
          icon: const Icon(Icons.chat),
          title: const Text('Chat'),
          badgeCount: 20,
          showBadge: true
        ),
        CustomNavigationBarItem(
          icon: const Icon(Icons.settings),
          title: const Text('Settings'),
        ),
      ],
    );
  }

  Widget _buildOldBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}

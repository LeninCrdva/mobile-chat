import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat/components/pages/chat_list_page.dart';
import 'package:simple_chat/components/pages/notifications_page.dart';
import 'package:simple_chat/components/pages/settings_page.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const ChatListPage(),
    const NotificationPage(),
    const ProfilePage(),
    const SettingsPage(),
  ];

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
          Navigator.pushNamed(context, '/create-chat');
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
        ),
        CustomNavigationBarItem(
          icon: const Icon(Icons.notifications),
          title: const Text('Notifications'),
        ),
        CustomNavigationBarItem(
          icon: const Icon(Icons.person),
          title: const Text('Profile'),
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

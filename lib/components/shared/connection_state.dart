import 'package:flutter/material.dart';
import 'package:internet_connectivity_checker/internet_connectivity_checker.dart';
import 'package:simple_chat/main.dart';
import 'package:simple_chat/src/model/chat.dart';
import 'package:simple_chat/src/service/chat_service.dart';

class WConnectionState extends StatefulWidget {
  const WConnectionState({super.key});

  @override
  State<WConnectionState> createState() => _WConnectionStateState();
}

class _WConnectionStateState extends State<WConnectionState> {
  final ChatService _chatSvc = ChatService(objectBox.store.box<Chat>());
  bool _isShowingDialog = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatSvc.startSseConnection();
    });
    super.initState();
  }

  @override
  void dispose() {
    _chatSvc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityBuilder(
      builder: (ConnectivityStatus status) {
        if (status == ConnectivityStatus.offline && !_isShowingDialog) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showConnectivityDialog();
          });
        }

        if (status == ConnectivityStatus.online && _isShowingDialog) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _closeDialog();
          });
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _showConnectivityDialog() {
    if (_isShowingDialog) return;

    setState(() {
      _isShowingDialog = true;
    });

    showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return WillPopScope(
          onWillPop: () async {
            return Future.value(false);
          },
          child: AlertDialog(
            title: const Text(
              'Connection Lost',
              textAlign: TextAlign.center,
            ),
            content: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(width: 10),
                  Text('Reconnecting...'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _closeDialog() {
    setState(() {
      _isShowingDialog = false;
    });
    Navigator.of(navigatorKey.currentContext!).pop();
  }
}

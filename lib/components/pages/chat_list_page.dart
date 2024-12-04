import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_chat/components/shared/profile_picture_dialog.dart';
import 'package:simple_chat/route/named_routes.dart';
import 'package:simple_chat/src/service/chat_service.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatService>(context);

    return ListView.builder(
      itemCount: provider.chats.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final chat = provider.chats[index];
        final lastMessage = chat.messages.isNotEmpty ? chat.messages.last : null;

        return cardChat(
          chat.info.target!.receiverAvatar,
          chat.info.target!.receiver,
          lastMessage?.content ?? 'No messages',
          chat.id,
        );
      },
    );
  }

  Widget cardChat(String imageUrl, String title, String subtitle, int chatId) {
    Future<void> handleTap() async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          NamedRoute.chat,
          arguments: [imageUrl, title, chatId],
        );
      }
    }
    return Material(
      child: InkWell(
        onTap: handleTap,
        splashColor: Colors.blue.withOpacity(0.1),
        highlightColor: Colors.blue.withOpacity(0.05),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        ProfilePictureDialog(
                          avatarUrl: imageUrl,
                          contactName: title,
                        ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(7),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

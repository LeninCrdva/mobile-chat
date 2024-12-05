import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_chat/components/shared/profile_picture_dialog.dart';
import 'package:simple_chat/route/named_routes.dart';
import 'package:simple_chat/src/service/chat_service.dart';
import 'package:simple_chat/utils/date.dart';

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
          lastMessage?.sendAt ?? DateTime.now(),
        );
      },
    );
  }

  Widget cardChat(String imageUrl, String title, String subtitle, int chatId, DateTime date) {

    handleTap() {
        Navigator.pushNamed(
          context,
          NamedRoute.chat,
          arguments: [imageUrl, title, chatId],
        );
    }

    return ListTile(
      leading: GestureDetector(
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
          margin: const EdgeInsets.all(1),
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
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      trailing: SizedBox(
        width: 60,
        child: Text(
          date.isAfter(DateTime.now().subtract(const Duration(days: 1)))
              ? DateUtilsConverter(date).onlyHour
              : DateUtilsConverter(date).onlyDate,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: handleTap,
    );
  }
}

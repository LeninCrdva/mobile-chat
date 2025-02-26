import 'package:flutter/material.dart';
import 'package:simple_chat/components/shared/profile_picture_dialog.dart';
import 'package:simple_chat/main.dart';
import 'package:simple_chat/route/named_routes.dart';
import 'package:simple_chat/src/model/chat.dart';
import 'package:simple_chat/src/service/chat_service.dart';
import 'package:simple_chat/utils/date.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatListPage> {
  ChatService chatService = ChatService(objectBox.store.box<Chat>());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatService.loadChats();
      chatService.createLocalChat();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatService.getDataByIdOrNotAsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final chats = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          itemCount: chats.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final chat = chats[index];

            final lastMessage =
                chat.messages.isNotEmpty ? chat.messages.last : null;

            return cardChat(
              chat.info.target!.receiverAvatar,
              chat.info.target!.receiver,
              lastMessage?.content ?? 'No messages',
              chat.id,
              lastMessage?.sendAt ?? DateTime.now(),
              lastMessage?.seenAt,
            );
          },
        );
      },
    );
  }

  Widget cardChat(String imageUrl, String title, String subtitle, int chatId,
      DateTime date, DateTime? seenAt) {
    handleTap() {
      Navigator.pushNamed(
        context,
        NamedRoute.chat,
        arguments: [imageUrl, title, chatId],
      );
    }

    final bool isSeen = seenAt != null;

    return ListTile(
      leading: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => ProfilePictureDialog(
              avatarUrl: imageUrl,
              contactName: title,
            ),
          );
        },
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.transparent,
          backgroundImage: const AssetImage('assets/icon/person-avatar.png'),
          foregroundImage: NetworkImage(imageUrl),
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
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontWeight: isSeen ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      trailing: SizedBox(
        width: 60,
        child: Text(
          date.isAfter(DateTime.now().subtract(const Duration(days: 1)))
              ? DateUtilsConverter(date).onlyHour
              : DateUtilsConverter(date).onlyDate,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      onTap: handleTap,
    );
  }
}

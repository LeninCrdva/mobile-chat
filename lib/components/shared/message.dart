import 'package:flutter/material.dart';
import 'package:simple_chat/utils/date.dart';

class MessageComponent extends StatefulWidget {
  final String message;
  final String receiverAvatar;
  final String sender;
  final String receiver;
  final bool isSender;
  final DateTime dateReceived;
  final bool isConsecutive;
  final bool isLastConsecutive;

  const MessageComponent({
    Key? key,
    required this.message,
    required this.sender,
    required this.receiver,
    required this.dateReceived,
    required this.isSender,
    required this.receiverAvatar,
    this.isConsecutive = false,
    this.isLastConsecutive = false,
  }) : super(key: key);

  @override
  State<MessageComponent> createState() => _MessageComponentState();
}

class _MessageComponentState extends State<MessageComponent> {
  @override
  Widget build(BuildContext context) {
    return _buildMessage();
  }

  Widget _buildMessage() {
    return Row(
      mainAxisAlignment:
      widget.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!widget.isSender && !widget.isConsecutive)
          CircleAvatar(
            backgroundImage: NetworkImage(widget.receiverAvatar),
          )
        else if (!widget.isSender)
          const SizedBox(width: 40),
        _buildMessageContentAndDate(),
      ],
    );
  }

  Widget _buildMessageContentAndDate() {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(
        bottom: widget.isLastConsecutive ? 10 : 2,
        left: 10,
        right: 10,
      ),
      padding: const EdgeInsets.all(10),
      constraints: BoxConstraints(maxWidth: deviceWidth * 0.8),
      decoration: _buildBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            child: Text(widget.message),
          ),
          if (widget.isLastConsecutive || !widget.isConsecutive)
            Text(
              DateUtilsConverter(widget.dateReceived).onlyHour,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.end,
            ),
        ],
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: widget.isSender ? Colors.cyanAccent[200] : Colors.blue[300],
      borderRadius: _buildBorderRadius(),
    );
  }

  BorderRadius _buildBorderRadius() {
    if (widget.isSender) {
      return BorderRadius.only(
        topLeft: const Radius.circular(10),
        bottomRight: widget.isLastConsecutive ? const Radius.circular(10) : const Radius.circular(2),
        bottomLeft: const Radius.circular(10),
        topRight: widget.isConsecutive ? const Radius.circular(2) : const Radius.circular(10),
      );
    } else {
      return BorderRadius.only(
        topRight: const Radius.circular(10),
        bottomLeft: widget.isLastConsecutive ? const Radius.circular(10) : const Radius.circular(2),
        bottomRight: const Radius.circular(10),
        topLeft: widget.isConsecutive ? const Radius.circular(2) : const Radius.circular(10),
      );
    }
  }
}
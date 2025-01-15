import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MessagingWidget extends StatelessWidget {
  const MessagingWidget({
    super.key,
    required this.text,
    required this.isFromUser
});

  final String text;
  final bool isFromUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20
              ),
              constraints: const BoxConstraints(maxWidth: 520),
              decoration: BoxDecoration(
                color: isFromUser ? Color(0xFF61828C) : Color(0xFF8EB1BB),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  MarkdownBody(data: text),
                ],
              ),
            ))
      ],
    );
  }
}
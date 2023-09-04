import 'package:flutter/material.dart';

class MyChatBubble extends StatelessWidget {
  final Widget child;

  const MyChatBubble({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFFFFF),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}

class OtherChatBubble extends StatelessWidget {
  final Widget child;
  const OtherChatBubble({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider_chat_app/services/chat/chat_service.dart';
import 'package:provider_chat_app/widgets/my_chat_bubble.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserID;
  final String receiverUserEmail;

  const ChatPage({
    super.key,
    required this.receiverUserID,
    required this.receiverUserEmail,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageCtrl = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final ScrollController _scrollCtrl;

  String get _firstName {
    String email = widget.receiverUserEmail;
    List<String> result = email.split('');
    return result.first.toUpperCase();
  }

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController();
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    double maxScroll = _scrollCtrl.position.maxScrollExtent;

    _scrollCtrl.animateTo(
      maxScroll,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void sendMessage() {
    if (_messageCtrl.text.isNotEmpty) {
      _chatService.sendMessage(
        receiverId: widget.receiverUserID,
        message: _messageCtrl.text,
      );

      _messageCtrl.clear();
      scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade100,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            CircleAvatar(
              child: Text(_firstName),
            ),
            const SizedBox(width: 12.0),
            Text(widget.receiverUserEmail),
          ],
        ),
      ),
      body: Column(
        children: [
          Flexible(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        userId: widget.receiverUserID,
        otherUserId: _auth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error : ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.15),
                  borderRadius: BorderRadius.circular(12.0)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Can aya babasa...',
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleMedium?.fontSize),
                  ),
                  const SizedBox(height: 18.0),
                  Text(
                    'Sapa heula atuh',
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleLarge?.fontSize),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView(
          controller: _scrollCtrl,
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    bool sameId = data['senderId'] == _auth.currentUser!.uid;

    Alignment alignment = sameId ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: sameId
          ? MyChatBubble(child: Text(data['message']))
          : OtherChatBubble(child: Text(data['message'])),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: TextField(
                controller: _messageCtrl,
                onTap: () {
                  scrollToBottom();
                },
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  isDense: true,
                  hintText: 'Message',
                ),
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            flex: 1,
            child: IconButton.filled(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48.0)),
              onPressed: sendMessage,
              icon: const Icon(Icons.send_rounded),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_chat_app/pages/chat_page.dart';
import 'package:provider_chat_app/services/auth/auth_service.dart';

import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() {
    final AuthService authService =
        Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            const Icon(Icons.chat_rounded),
            const SizedBox(width: 8.0),
            Text(
              'NgobrolApp',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout))
        ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error : ${snapshot.hasError}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    String firstName() {
      String email = data['email'];
      List<String> result = email.split('');
      return result.first.toUpperCase();
    }

    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        leading: CircleAvatar(
          child: Text(firstName()),
        ),
        title: Text(data['email']),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserID: data['uid'],
                receiverUserEmail: data['email'],
              ),
            ),
          );
        },
      );
    }

    return Container();
  }
}

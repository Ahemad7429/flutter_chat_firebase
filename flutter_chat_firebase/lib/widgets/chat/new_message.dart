import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var enteredMessage = '';
  var _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void sendMessage() async {
    final user = await FirebaseAuth.instance.currentUser();
    final userDetails =
        await Firestore.instance.collection('users').document(user.uid).get();
    FocusScope.of(context).unfocus();
    Firestore.instance.collection('chat').add({
      'text': enteredMessage.trim(),
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userDetails['username'],
      'image_url': userDetails['image_url'],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Send a message...',
              ),
              onChanged: (value) {
                setState(() {
                  enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.send),
            onPressed: enteredMessage.trim().isEmpty ? null : sendMessage,
          )
        ],
      ),
    );
  }
}

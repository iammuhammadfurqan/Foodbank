import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String username;

  ChatScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(username),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Message $index'),
                );
              },
              itemCount: 3,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          username: 'Asad',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Confirmation'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ChatsOverviewScreen extends StatelessWidget {
  const ChatsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatsOverviewScreen extends StatefulWidget {
  const ChatsOverviewScreen({super.key});

  @override
  State<ChatsOverviewScreen> createState() => _ChatsOverviewScreenState();
}

class _ChatsOverviewScreenState extends State<ChatsOverviewScreen> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> chats = [];

  void fetchChats() {
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

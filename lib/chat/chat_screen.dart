import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbank/utils.dart';

import '../pages/shortest_path_screen.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final bool isVolunteer;
  final String receiverName;
  final String donationId;

  const ChatScreen(
      {super.key,
      required this.receiverId,
      required this.receiverName,
      required this.isVolunteer,
      required this.donationId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();

  var showButton = false;

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await sendMessage2(messageController.text.trim(), widget.receiverId);
      messageController.clear();
    }
  }

  var showMapIcon = false;
  //a function that will check of a particular donation is active or not
  Future<void> checkIfActive() async {
    print("donation id: " + widget.donationId);
    await FirebaseFirestore.instance
        .collection('donations')
        .doc(widget.donationId)
        .get()
        .then((value) {
      if (value.data()!['isActive']) {
        setState(() {
          showMapIcon = true;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfActive();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
        actions: [
          !widget.isVolunteer
              ? IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    //show a confirm dialog
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                                "Confirm order and provide Location"),
                            content: const Text(
                                "Are you sure you want to mark this request as completed?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  //mark the request as completed
                                  FirebaseFirestore.instance
                                      .collection("donations")
                                      .doc(widget.donationId)
                                      .update({"status": "completed"}).then(
                                          (value) {
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Text("Confirm"),
                              ),
                            ],
                          );
                        });
                  },
                )
              : showMapIcon
                  ? IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShortestPathScreen(
                                      donationId: widget.donationId,
                                    )));
                      },
                      icon: const Icon(Icons.map_outlined))
                  : const SizedBox(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Expanded(child: _buildMessageList()),
          _buildMessageComposer(),
        ]),
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Row(children: [
      Expanded(
        child: TextField(
          controller: messageController,
          decoration: const InputDecoration.collapsed(
            hintText: "Send a message",
          ),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.send),
        onPressed: () {
          sendMessage();
        },
      ),
    ]);
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    var allignment = data['senderId'] == FirebaseAuth.instance.currentUser!.uid
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: allignment,
      child: Column(
        children: [
          //Text(data['name']),
          const SizedBox(height: 3),
          chatBubble(
              data['message'],
              data['senderId'] == FirebaseAuth.instance.currentUser!.uid,
              data['timeStamp']),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream:
          getMessage(widget.receiverId, FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }
}

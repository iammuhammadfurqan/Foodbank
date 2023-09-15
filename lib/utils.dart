import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'chat/message.dart';

Future<Position?> determinePosition() async {
  //print("determinePosition");
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      await Geolocator.openAppSettings();
      // return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    await Geolocator.openAppSettings();
    //return Future.error(
    //    'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  //print(Geolocator.getCurrentPosition());
  //show a snackar to display the location
  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
    //print latitude and longitude
    print(await Geolocator.getCurrentPosition());

    return await Geolocator.getCurrentPosition();
  }

  //return await Geolocator.getCurrentPosition();
}

String extractLatLng(String input) {
  // Remove "LatLng(" and ")" from the input string
  String cleanInput = input.replaceAll('LatLng(', '').replaceAll(')', '');

  // Split the clean input into latitude and longitude parts
  List<String> parts = cleanInput.split(', ');

  if (parts.length != 2) {
    throw Exception('Invalid input format');
  }

  // Extract latitude and longitude
  double latitude = double.parse(parts[0]);
  double longitude = double.parse(parts[1]);

  return '$latitude,$longitude';
}

Future<void> sendMessage2(String message, String receiverId) async {
  //get current user info
  final String currUserId = FirebaseAuth.instance.currentUser!.uid;
  //get the name of the current user
  var name = "";
  await FirebaseFirestore.instance
      .collection("users")
      .doc(currUserId)
      .get()
      .then((value) {
    name = value.data()!['name'];
  });

  //create a new message from message.dart
  Message myMessage = Message(
    senderId: currUserId,
    receiverId: receiverId,
    name: name,
    message: message,
    timeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
  );

  //construct chatroom id from sender id and receiver id (sorted alphabetically to ensure uniqueness)
  String chatRoomId = getChatRoomId(currUserId, receiverId);

  //add new message to database
  await FirebaseFirestore.instance
      .collection("chatRoom")
      .doc(chatRoomId)
      .collection("chats")
      .add(myMessage.toMap(myMessage));
}

String getChatRoomId(String currUserId, String receiverId) {
  //sort the ids alphabetically
  List<String> ids = [currUserId, receiverId];
  ids.sort();

  //concatenate the ids
  String chatRoomId = "${ids[0]}_${ids[1]}";

  return chatRoomId;
}

//get Message

Stream<QuerySnapshot> getMessage(String userId, String otherUserId) {
  //construct chatroom id from sender id and receiver id (sorted alphabetically to ensure uniqueness)
  String chatRoomId = getChatRoomId(userId, otherUserId);
  print("chat room id:" + chatRoomId);

  return FirebaseFirestore.instance
      .collection("chatRoom")
      .doc(chatRoomId)
      .collection("chats")
      .orderBy("timeStamp", descending: false)
      .snapshots();
}

Widget chatBubble(String message, bool isMe, String timeStamp) {
  //convert the time stamp into date difference
  var date = DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp));
  //get the difference between the current date and the date of the message
  var difference = DateTime.now().difference(date);

  //convert the difference into a readable format
  String differenceString = "";
  if (difference.inDays > 0) {
    differenceString = "${difference.inDays} days ago";
  } else if (difference.inHours > 0) {
    differenceString = "${difference.inHours} hr ago";
  } else if (difference.inMinutes > 0) {
    differenceString = "${difference.inMinutes} min ago";
  } else if (difference.inSeconds > 0) {
    differenceString = "${difference.inSeconds} sec ago";
  } else {
    differenceString = "Just now";
  }

  return Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.symmetric(vertical: 5),
    decoration: BoxDecoration(
      color: isMe ? Colors.blue : Colors.grey[300],
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          differenceString.toString(),
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
            fontSize: 10,
          ),
        ),
      ],
    ),
  );
}

class CustomMarker {
  final String id;
  final String pictureUrl;
  final String name;
  final String description;
  final double latitude;
  final double longitude;

  CustomMarker({
    required this.id,
    required this.pictureUrl,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
  });
}

import 'package:flutter/material.dart';

class FoodRequestWidget extends StatelessWidget {
  final String name;
  final String foodType;
  final String imgUrl;
  final VoidCallback? deleteRequest;
  final VoidCallback? chatUser;

  const FoodRequestWidget(
      {super.key,
      required this.name,
      required this.foodType,
      this.deleteRequest,
      this.chatUser,
      required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(imgUrl),
            ),
            title: Text(name),
            subtitle: Text(foodType),
            //isThreeLine: true,
            //subtitle: Text("$quantity pieces"),
            trailing:
                //2 buttons with text chat and decline
                Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //chat button
                TextButton(
                  onPressed: () {
                    chatUser!();
                  },
                  child: const Text(
                    "Chat",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //decline button
                TextButton(
                  onPressed: () {
                    deleteRequest!();
                  },
                  child: const Text(
                    "Decline",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )));
  }
}

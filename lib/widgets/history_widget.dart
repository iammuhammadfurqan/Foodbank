import 'package:flutter/material.dart';

class HistoryWidget extends StatelessWidget {
  final String foodType;
  final String date;
  final String imageUrl;
  final String quantity;
  final bool isActive;

  const HistoryWidget(
      {super.key,
      required this.foodType,
      required this.date,
      required this.imageUrl,
      required this.quantity,
      required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(foodType),
        subtitle: Text("$quantity pieces"),
        trailing: isActive ? const Text("Ongoing") : const Text("Completed"),
      ),
    );
  }
}

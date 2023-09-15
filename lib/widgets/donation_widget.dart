import 'package:flutter/material.dart';

class DonationWidget extends StatelessWidget {
  final String foodType;
  final String date;
  final String imageUrl;
  final String location;
  final String quantity;
  final String time;
  final bool isNGO;
  final String organizationId;
  final VoidCallback? viewDonation;
  final VoidCallback? deleteDonation;

  const DonationWidget(
      {super.key,
      required this.foodType,
      required this.date,
      required this.imageUrl,
      required this.location,
      required this.quantity,
      required this.time,
      required this.isNGO,
      required this.organizationId,
      this.viewDonation,
      this.deleteDonation});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(foodType),
        subtitle: Text("$quantity pieces"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // IconButton(
            //     onPressed: () {}, icon: const Icon(Icons.remove_red_eye)),
            // const SizedBox(width: 10),
            IconButton(
                onPressed: () {
                  deleteDonation!();
                },
                icon: const Icon(Icons.delete)),
          ],
        ),
        onTap: () {
          // Navigator.pushNamed(context, '/donationDetails', arguments: {
          //   'foodType': foodType,
          //   'date': date,
          //   'imageUrl': imageUrl,
          //   'location': location,
          //   'quantity': quantity,
          //   'time': time,
          //   'isNGO': isNGO,
          //   'organizationId': organizationId,
          // });
        },
      ),
    );
  }
}

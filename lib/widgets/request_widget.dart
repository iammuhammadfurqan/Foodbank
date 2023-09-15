import 'package:flutter/material.dart';

class RequestWidget extends StatelessWidget {
  final String donationId;
  final String userId;
  final String status;
  final VoidCallback? deleteRequest;
  final VoidCallback? startChat;

  final String foodType;
  final String imageUrl;
  final String quantity;
  final bool isActive;
  const RequestWidget(
      {super.key,
      required this.donationId,
      required this.userId,
      required this.status,
      this.deleteRequest,
      this.startChat,
      required this.foodType,
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            status == "pending"
                ?
                //show a bordered text with outline border
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.orange,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Pending",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : status == "accepted"
                    ?
                    //show a bordered text with outline border
                    GestureDetector(
                        onTap: () {
                          startChat!();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Chat",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    :
                    //show a bordered text with outline border
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Declined",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
            if (status != "accepted")
              IconButton(
                  onPressed: () => deleteRequest!(),
                  icon: const Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}

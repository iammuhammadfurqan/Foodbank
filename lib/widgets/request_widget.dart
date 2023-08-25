import 'dart:ffi';

import 'package:flutter/material.dart';

class RequestWidget extends StatelessWidget {
  final String donationId;
  final String userId;
  final String status;
  final VoidCallback? deleteRequest;
  const RequestWidget(
      {super.key,
      required this.donationId,
      required this.userId,
      required this.status,
      this.deleteRequest});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(donationId),
        //subtitle: Text("$quantity pieces"),
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
                    Container(
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
                            "Accepted",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
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
            IconButton(
                onPressed: () => deleteRequest!(),
                icon: const Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}

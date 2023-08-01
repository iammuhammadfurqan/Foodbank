import 'package:flutter/material.dart';
import 'package:foodbank/adDetails.dart';
import 'package:foodbank/adDetailsActiveRequest.dart';

class ActiveRequest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Handle back button press
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Active Requests!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 3, // replace with actual item count
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AdDetailsRequestVolunteer())); // handle click action
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/food.png',
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Food Type'),
                                Text('Category of food'),
                                Text('Date'),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // handle delete action
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

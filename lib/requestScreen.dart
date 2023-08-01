import 'package:flutter/material.dart';
import 'package:foodbank/donatorProfile.dart';
import 'package:foodbank/homeScreen.dart';

import 'chatScreen.dart';

class RequestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Requests"),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text("Pending!", style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/profile.png"),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("John Doe", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 4),
                        Text("5 minutes ago",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    Icon(Icons.star, color: Colors.amber),
                    Icon(Icons.star, color: Colors.amber),
                    Icon(Icons.star_half, color: Colors.amber),
                    Icon(Icons.star_border, color: Colors.amber),
                    SizedBox(width: 8),
                    Text("4.5", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/profile.png"),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("John Doe", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 4),
                        Text("5 minutes ago",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    Icon(Icons.star, color: Colors.amber),
                    Icon(Icons.star, color: Colors.amber),
                    Icon(Icons.star_half, color: Colors.amber),
                    Icon(Icons.star_border, color: Colors.amber),
                    SizedBox(width: 8),
                    Text("4.5", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/profile.png"),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("John Doe", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 4),
                        Text("5 minutes ago",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                    username: 'Asad',
                                  )),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    Icon(Icons.star, color: Colors.amber),
                    Icon(Icons.star, color: Colors.amber),
                    Icon(Icons.star_half, color: Colors.amber),
                    Icon(Icons.star_border, color: Colors.amber),
                    SizedBox(width: 8),
                    Text("4.5", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.all(12),
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      icon: Icon(Icons.home),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DonatorProfile()),
                        );
                      },
                      icon: Icon(Icons.person),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              username: "Asad",
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.chat),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

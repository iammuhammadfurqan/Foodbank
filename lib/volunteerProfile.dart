import 'package:flutter/material.dart';
import 'package:foodbank/activeRequestVolunteer.dart';

import 'package:foodbank/loginPageReceiver.dart';
import 'package:foodbank/updateProfile.dart';
import 'package:foodbank/userHistory.dart';

class VolunteerProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Volunteer Profile",
            style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
          SizedBox(height: 20),
          Text(
            'Muhammad',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'muhammad@gmail.com',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 30),
          Text(
            "Welcome Back!",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileUpdateScreen())); // handle icon click
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 14),
                      Text(
                        'Update Profile',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ActiveRequest())); // handle icon click
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.volunteer_activism_rounded),
                      SizedBox(width: 14),
                      Text(
                        'Active Request',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UserHistory())); // handle icon click
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.history_outlined),
                      SizedBox(width: 14),
                      Text(
                        'My History',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginPageReceiver())); // handle icon click
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 14),
                      Text(
                        'Logout',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

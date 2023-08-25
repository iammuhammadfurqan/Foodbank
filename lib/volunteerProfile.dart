import 'package:flutter/material.dart';
import 'package:foodbank/activeRequestVolunteer.dart';

import 'package:foodbank/loginPageReceiver.dart';
import 'package:foodbank/updateProfile.dart';
import 'package:foodbank/userHistory.dart';

class VolunteerProfile extends StatelessWidget {
  const VolunteerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Volunteer Profile",
            style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Muhammad',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'muhammad@gmail.com',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          const Text(
            "Welcome Back!",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ProfileUpdateScreen())); // handle icon click
                  },
                  child: const Row(
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
                const SizedBox(
                  height: 14,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ActiveRequest())); // handle icon click
                  },
                  child: const Row(
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
                const SizedBox(
                  height: 14,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const UserHistory())); // handle icon click
                  },
                  child: const Row(
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
                const SizedBox(
                  height: 14,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const LoginPageReceiver())); // handle icon click
                  },
                  child: const Row(
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
                const SizedBox(
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

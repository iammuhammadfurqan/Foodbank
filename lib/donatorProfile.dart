import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbank/activeDonationDonor.dart';
import 'package:foodbank/activeRequestVolunteer.dart';
import 'package:foodbank/loginPage.dart';
import 'package:foodbank/pages/requests_page.dart';
import 'package:foodbank/updateProfile.dart';
import 'package:foodbank/userHistory.dart';

class DonatorProfile extends StatefulWidget {
  const DonatorProfile({super.key});

  @override
  State<DonatorProfile> createState() => _DonatorProfileState();
}

class _DonatorProfileState extends State<DonatorProfile> {
  var isLoading = false;
  var _userName = '';
  var _userEmail = '';
  var _userPhone = '';
  var _userType = 'User';
  //a function to fetch the current user data from firebase

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    print(user!.uid);
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    setState(() {
      _userEmail = userData['email'];
      _userName = userData['name'];
      _userPhone = userData['number'];
      _userType = userData['userType'];
      isLoading = false;
    });
    print(_userEmail);
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' $_userType Profile'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  //  Text(
                  //   "$_userType Profile",
                  //   style: const TextStyle(
                  //       fontSize: 20,
                  //       color: Colors.black87,
                  //       fontWeight: FontWeight.w900),
                  // ),
                  const SizedBox(height: 10),
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                  const SizedBox(height: 0),
                  Text(
                    _userName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _userEmail,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  // const SizedBox(height: 10),
                  // Text(
                  //   _userType,
                  //   style: const TextStyle(fontSize: 16, color: Colors.grey),
                  // ),
                  // Text(
                  //   _userPhone,
                  //   style: const TextStyle(fontSize: 16, color: Colors.grey),
                  // ),

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
                                      const ProfileUpdateScreen()),
                            ); // handle icon click
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
                            _userType == "Volunteer"
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ActiveRequestsPage()))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ActiveDonations())); // handle icon click
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.volunteer_activism_rounded),
                              const SizedBox(width: 14),
                              _userType == "Volunteer"
                                  ? const Text('Active Requests',
                                      style: TextStyle(fontSize: 24))
                                  : const Text(
                                      'Active Donations',
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
                            FirebaseAuth.instance.signOut().then((value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                            });
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
            ),
    );
  }
}

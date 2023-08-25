import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:foodbank/chatScreen.dart';
import 'package:foodbank/donatorProfile.dart';
import 'package:foodbank/widgets/Map.dart';

import 'package:foodbank/widgets/donationType.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, Key? key1});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isVolunteer = false;
  var isLoading = false;

  //a function to get a user's data from firebase and check if the user is of type volunter
  Future<void> checkUserType() async {
    setState(() {
      isLoading = true;
    });
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    DocumentSnapshot userSnapshot =
        await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
    if (userSnapshot.exists) {
      // user exists in Firestore, navigate to home screen
      if (userSnapshot['userType'] == 'Volunteer') {
        setState(() {
          isVolunteer = true;
          isLoading = false;
        });
      }
    } else {
      // user doesn't exist in Firestore, show error message
      print('No user found for that email in Firestore.');
    }
  }

  @override
  void initState() {
    super.initState();
    checkUserType();
  }

  int _selectedIndex = 0;

  void _navigationBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          if (isVolunteer)
            IconButton(
                color: Colors.black,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapGoogle(
                                isVolunteer: isVolunteer,
                              )));
                },
                icon: const Icon(Icons.map)),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isVolunteer ? 'Request Food' : 'Let\'s Donate',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Click on the Map icon above to find what food is available near you.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (!isVolunteer)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const DonationType()));
                                  },
                                  child: const Text('Donate'),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Nourishing the Needy',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CarouselSlider(
                      items: [
                        Image.asset('assets/images/donator1.jfif'),
                        Image.asset('assets/images/donator2.png'),
                        Image.asset('assets/images/donator3.png'),
                      ],
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigationBottomBar,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DonatorProfile()));
              },
              child: const Icon(Icons.person),
            ),
            label: "Profile",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map",
          ),
        ],
      ),
    );
  }
}

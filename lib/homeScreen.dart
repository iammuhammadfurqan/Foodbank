import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:foodbank/donatorProfile.dart';
import 'package:foodbank/pages/chats_overview_screen.dart';
import 'package:foodbank/pages/food_requests_page.dart';
import 'package:foodbank/pages/requests_page.dart';
import 'package:foodbank/widgets/Map.dart';

import 'package:foodbank/widgets/donationType.dart';

import 'activeDonationDonor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, Key? key1});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        });
      }
    } else {
      // user doesn't exist in Firestore, show error message
      print('No user found for that email in Firestore.');
    }

    setState(() {
      isLoading = false;
    });
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
        title: _selectedIndex == 0 ? const Text('Home') : const Text('Profile'),
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
          : _selectedIndex == 0
              ? HomeWidget(isVolunteer: isVolunteer)
              : const DonatorProfile(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigationBottomBar,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
    required this.isVolunteer,
  });

  final bool isVolunteer;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  isVolunteer
                      ? Text(
                          'Click on the Map icon above to find what food is available near you.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        )
                      : Text(
                          'Click on the Donate button below to donate food.',
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    isVolunteer
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ActiveRequestsPage(
                                      isVolunteer: isVolunteer,
                                    )))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ActiveDonations())); // handle icon click
                  },
                  child: Container(
                    //give border of black color and thickness of 2
                    decoration: BoxDecoration(
                      //border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: isVolunteer ? Colors.orange : Colors.green,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      child: isVolunteer
                          ? const Row(
                              children: [
                                Text('Active Requests',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal)),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.arrow_outward,
                                  color: Colors.white,
                                ),
                              ],
                            )
                          : const Text(
                              'Active Donations',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ),
                  ),
                ),
                if (!isVolunteer)
                  Container(
                    //give border of black color and thickness of 2
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                      //color: Colors.orange,
                    ),

                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FoodRequestsPage(
                                      isVolunteer: isVolunteer,
                                    ))); // handle icon click
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        child: Row(
                          children: [
                            Text(
                              'Food Requests',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_forward, color: Colors.black),
                            //set the icon to the top right of text

                            // Positioned(
                            //   top: 0,
                            //   right: 0,
                            //   child: Icon(
                            //     Icons.arrow_forward,
                            //     color: Colors.white,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

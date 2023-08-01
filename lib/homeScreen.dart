import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:foodbank/chatScreen.dart';
import 'package:foodbank/donatorProfile.dart';
import 'package:foodbank/mapInterfaceVolunteer.dart';
import 'package:foodbank/widgets/Map.dart';

import 'package:foodbank/widgets/donationType.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _navigationBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    HomePage(),
    DonatorProfile(),
    ChatScreen(username: "hussnain")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
              color: Colors.black,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapGoogle()));
              },
              icon: const Icon(Icons.map)),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
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
                          'Let\'s Donate',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Every meal donated is not just food, but a message of hope and compassion to those in need, reminding them that they are not alone in this world.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DonationType()));
                          },
                          child: Text('Donate'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Nourishing the Needy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
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
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigationBottomBar,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DonatorProfile()));
              },
              child: Icon(Icons.person),
            ),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map",
          ),
        ],
      ),
    );
  }
}

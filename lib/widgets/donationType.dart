import 'package:flutter/material.dart';
import './donationDetails.dart';
import './donationDetailsNGO.dart';

class DonationType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Implement back button functionality here
          },
        ),
        title: Text('My Donation'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('./assets/images/breakfast.png'),
              SizedBox(height: 16),
              Text(
                'Food Bank',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),
              Text(
                'Want to share food?',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Select Method',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/images/food.png'),
                        radius: 40,
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DonationDetail()));
                        },
                        child: Text('Individual'),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Text('or'),
                  SizedBox(width: 16),
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/images/food.png'),
                        radius: 40,
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DonationDetailNGO()));
                        },
                        child: Text('NGO Agent'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

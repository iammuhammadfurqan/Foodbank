import 'package:flutter/material.dart';
import './donationDetails.dart';
import './donationDetailsNGO.dart';

class DonationType extends StatelessWidget {
  const DonationType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Implement back button functionality here
          },
        ),
        title: const Text('My Donation'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('./assets/images/breakfast.png'),
              const SizedBox(height: 16),
              const Text(
                'Food Bank',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              const Text(
                'Want to share food?',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select Method',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/food.png'),
                        radius: 40,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DonationDetailNGO(
                                        isNGO: false,
                                      )));
                        },
                        child: const Text('Individual'),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  const Text('or'),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/food.png'),
                        radius: 40,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DonationDetailNGO(
                                        isNGO: true,
                                      )));
                        },
                        child: const Text('NGO Agent'),
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

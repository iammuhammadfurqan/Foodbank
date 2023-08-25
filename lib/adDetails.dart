import 'package:flutter/material.dart';

class AdDetails extends StatelessWidget {
  const AdDetails({super.key});

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
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'User History',
                child: Text('User History'),
              ),
            ],
            onSelected: (value) {
              if (value == 'User History') {
                // Implement User History functionality here
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile.png'),
                  radius: 40,
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.yellow),
                    Text(
                      '4.5', // Replace this with the user's rating
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  'assets/images/food.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Food Type'),
                  Text('Pizza'), // Replace this with the dynamic food type
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Preferred Time'),
                  Text(
                      '12:00 PM'), // Replace this with the dynamic preferred time
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Preferred Date'),
                  Text(
                      '2023-04-01'), // Replace this with the dynamic preferred date
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Food Quantity'),
                  Text('2'), // Replace this with the dynamic food quantity
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Implement request button functionality here
                  },
                  child: const Text('Request'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

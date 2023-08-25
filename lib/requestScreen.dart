import 'package:flutter/material.dart';
import 'package:foodbank/donatorProfile.dart';
import 'package:foodbank/homeScreen.dart';

import 'chatScreen.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Requests"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text("Pending!", style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/profile.png"),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("John Doe", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 4),
                        Text("5 minutes ago",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Row(
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
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/profile.png"),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("John Doe", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 4),
                        Text("5 minutes ago",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Row(
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
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage("assets/images/profile.png"),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("John Doe", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 4),
                        Text("5 minutes ago",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChatScreen(
                                    username: 'Asad',
                                  )),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Row(
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
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                      },
                      icon: const Icon(Icons.home),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DonatorProfile()),
                        );
                      },
                      icon: const Icon(Icons.person),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatScreen(
                              username: "Asad",
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.chat),
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

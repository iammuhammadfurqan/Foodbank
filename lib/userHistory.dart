import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbank/widgets/donation_widget.dart';

class UserHistory extends StatefulWidget {
  const UserHistory({super.key});

  @override
  State<UserHistory> createState() => _UserHistoryState();
}

class _UserHistoryState extends State<UserHistory> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> donations = [];
  bool isLoading = false;
  void fetchDonations() {
    print(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance
        .collection('donations')
        .where("donator", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      print(value.docs);
      List<QueryDocumentSnapshot<Map<String, dynamic>>> dat = value.docs;
      if (dat.isNotEmpty) {
        setState(() {
          donations = dat;
        });
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    fetchDonations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your past donations (All time)s',
          style: TextStyle(
              fontSize: 0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: donations.isEmpty
                        ? const Text("No Active donations.")
                        : const Text(""),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          child: DonationWidget(
                              foodType: donations[index]['foodType'],
                              date: donations[index]['preferredDate'],
                              imageUrl: donations[index]['image'],
                              location: donations[index]['location'],
                              quantity: donations[index]['quantity'],
                              time: donations[index]['preferredTime'],
                              isNGO: donations[index]['isNGO'],
                              organizationId: donations[index]
                                  ['organization_id'],
                              deleteDonation: () {} //delete donation
                              ),
                        );
                      },
                      itemCount: donations.length,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

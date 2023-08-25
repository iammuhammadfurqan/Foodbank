import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbank/widgets/donation_widget.dart';

import 'utils.dart';

class ActiveDonations extends StatefulWidget {
  const ActiveDonations({super.key});

  @override
  State<ActiveDonations> createState() => _ActiveDonationsState();
}

class _ActiveDonationsState extends State<ActiveDonations> {
  // make a list of donations
  // make a function to fetch the donations from firebase
  // call the function in initState
  // use the list to populate the listview

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
        .where("isActive", isEqualTo: true)
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

  void deleteDonation(String id) {
    //show a dialog box to confirm deletion
    //if yes, delete the donation
    //if no, do nothing
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Donation"),
        content: const Text("Are you sure you want to delete this donation?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('donations')
                  .doc(id)
                  .delete()
                  .then((value) {
                Navigator.pop(context);
                fetchDonations();
              });
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
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
        title: const Text('Active Donations'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Handle back button press
          },
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
                            organizationId: donations[index]['organization_id'],
                            deleteDonation: () => deleteDonation(
                                donations[index].id), //delete donation
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

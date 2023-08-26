import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/request_widget.dart';

class FoodRequestsPage extends StatefulWidget {
  const FoodRequestsPage({super.key});

  @override
  State<FoodRequestsPage> createState() => _FoodRequestsPageState();
}

class _FoodRequestsPageState extends State<FoodRequestsPage> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> requests = [];
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
      List<QueryDocumentSnapshot<Map<String, dynamic>>> dat = value.docs;
      if (dat.isNotEmpty) {
        setState(() {
          donations = dat;
        });
      }

      fetchRequestersDetails();
    });
  }

  //a function that will loop through each donation and fetch requesters array
  //then for each requester id, fetch the user details

  void fetchRequestersDetails() {
    print(donations.length);
    for (var donation in donations) {
      for (var id in donation.data()["requesters"]) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(id)
            .get()
            .then((value) {
          print(value.data()!['name']);
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDonations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Received Requests"),
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
                    child: requests.isEmpty
                        ? const Text("You haven't received any requets")
                        : const Text(""),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: RequestWidget(
                              donationId: requests[index]['donationId'],
                              userId: requests[index]['userId'],
                              status: requests[index]['status'],
                            ));
                      },
                      itemCount: requests.length,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

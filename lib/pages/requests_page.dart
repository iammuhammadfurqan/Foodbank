import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbank/widgets/donation_widget.dart';
import 'package:foodbank/widgets/request_widget.dart';

class ActiveRequestsPage extends StatefulWidget {
  const ActiveRequestsPage({super.key});

  @override
  State<ActiveRequestsPage> createState() => _ActiveRequestsPage();
}

class _ActiveRequestsPage extends State<ActiveRequestsPage> {
  // make a list of donations
  // make a function to fetch the donations from firebase
  // call the function in initState
  // use the list to populate the listview

  List<QueryDocumentSnapshot<Map<String, dynamic>>> requests = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> donations = [];
  bool isLoading = false;
  void fetchRequets() {
    print(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance
        .collection('requests')
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      print(value.docs);
      List<QueryDocumentSnapshot<Map<String, dynamic>>> dat = value.docs;
      if (dat.isNotEmpty) {
        setState(() {
          requests = dat;
        });

        for (var request in requests) {
          fetchDonationDetails(request.id);
        }
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  // a function that will fetch the donation details using the donation id
  // loop through the requests list and find the donation with the given id

  void fetchDonationDetails(String donationId) {
    FirebaseFirestore.instance
        .collection('donations')
        .where("requesters", arrayContains: donationId)
        .get()
        .then((value) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> dat = value.docs;

      setState(() {
        donations = dat;
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
                fetchRequets();
              });
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void delRequest(String reqId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Request"),
        content: const Text("Are you sure you want to delete this request?"),
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
                  .collection('requests')
                  .doc(reqId)
                  .delete()
                  .then((value) {
                Navigator.pop(context);
                fetchRequets();
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
    fetchRequets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Requests'),
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
                    child: requests.isEmpty
                        ? const Text("No Active Requests.")
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
                              deleteRequest: () =>
                                  delRequest(requests[index].id),
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

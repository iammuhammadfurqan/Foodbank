import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbank/widgets/history_widget.dart';

class UserHistoryVolunteer extends StatefulWidget {
  const UserHistoryVolunteer({super.key});

  @override
  State<UserHistoryVolunteer> createState() => _UserHistoryVolunteerState();
}

class _UserHistoryVolunteerState extends State<UserHistoryVolunteer> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> requests = [];
  bool isLoading = false;
  void fetchRequests() {
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
      }

      fetchDonationDetails();
    });
  }

  //for every request, fetch the donation details
  //get the donation id from the request and fetch the donation details
  //store the donation details in a map

  var data = {};

  Future<void> fetchDonationDetails() async {
    //loop through the requests list and find the donation with the given id
    for (var request in requests) {
      await FirebaseFirestore.instance
          .collection('donations')
          .doc(request['donationId'])
          .get()
          .then((value) {
        setState(() {
          data[request.id] = value.data();
        });
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your past requests',
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
                  data.values.isEmpty
                      ? const Center(child: Text("No history yet."))
                      :
                      //loop through the data map and show the FoodRequestWidget
                      Expanded(
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return HistoryWidget(
                                foodType:
                                    data.values.elementAt(index)['foodType'],
                                date: data.values
                                    .elementAt(index)['preferredDate'],
                                imageUrl: data.values.elementAt(index)['image'],
                                quantity:
                                    data.values.elementAt(index)['quantity'],
                                isActive:
                                    data.values.elementAt(index)['isActive'],
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbank/widgets/food_request_widget.dart';

import '../widgets/request_widget.dart';

class FoodRequestsPage extends StatefulWidget {
  const FoodRequestsPage({super.key});

  @override
  State<FoodRequestsPage> createState() => _FoodRequestsPageState();
}

class _FoodRequestsPageState extends State<FoodRequestsPage> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> requests = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> donations = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> users = [];
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
      fetchUsers();
    });
  }

  //a function that will loop through each donation and fetch requesters array
  //then for each requester id, fetch the user details
  var data = {};

  var requesters = {};

  void fetchRequestersDetails() {
    print(donations.length);
    print(users.length);
    for (var donation in donations) {
      //store the donation id in the data map
      data[donation.id] = [];
      for (var id in donation.data()["requesters"]) {
        //add the requester id to the requesters map along with the donation id
        requesters[donation.id] = id;

        for (var user in users) {
          if (user.id == id) {
            print("user id: " + user.id);
            data[donation.id].add(user.data());
          }
        }
      }
    }

    if (data.length == 1) {}

    print(data);

    setState(() {
      isLoading = false;
    });
  }

  // a fucntion that will get all the users details
  void fetchUsers() {
    print("fetching users");
    FirebaseFirestore.instance.collection('users').get().then((value) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> dat = value.docs;
      if (dat.isNotEmpty) {
        setState(() {
          users = dat;
        });
      }
      fetchRequestersDetails();
    });
  }

  void declineRequest(String id) {
    print("req id: " + id);
    //update the status in requests collection

    FirebaseFirestore.instance
        .collection('requests')
        .where("userId", isEqualTo: id)
        .get()
        .then((value) {
      print(value.docs[0].id);
      FirebaseFirestore.instance
          .collection('requests')
          .doc(value.docs[0].id)
          .update({
        "status": "declined",
      }).then((value) {
        //remove the id from the requesters array in donations collection
        FirebaseFirestore.instance
            .collection('donations')
            .doc(donations[0].id)
            .update({
          "requesters": FieldValue.arrayRemove([id])
        }).then((value) {
          //show a snackbar
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Request declined"),
          ));
        });

        setState(() {
          data.remove(donations[0].id);
        });
      });
    });

    // ({
    //   "status": "declined",
    // }).then((value) {
    //   //remove the id from the requesters array in donations collection
    //   FirebaseFirestore.instance
    //       .collection('donations')
    //       .doc(donations[0].id)
    //       .update({
    //     "requesters": FieldValue.arrayRemove([id])
    //   }).then((value) {
    //     //show a snackbar
    //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text("Request declined"),
    //     ));
    //   });

    //   fetchDonations();
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDonations();
  }

  @override
  Widget build(BuildContext context) {
    print("bool:" +
        data.values.first.toString().replaceAll("[]", "").isEmpty.toString());
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
                  data.values.first.toString().replaceAll("[]", "").isEmpty
                      ? const Center(
                          child: Text("You haven't received any requets"))
                      :
                      //loop through the data map and show the FoodRequestWidget
                      Expanded(
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return FoodRequestWidget(
                                name: data[donations[index].id][0]["name"],
                                foodType: donations[index].data()["foodType"],
                                deleteRequest: () => declineRequest(
                                  requesters[donations[index].id],
                                ),
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

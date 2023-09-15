import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbank/widgets/food_request_widget.dart';

import '../chat/chat_screen.dart';
import '../widgets/request_widget.dart';

class FoodRequestsPage extends StatefulWidget {
  final bool isVolunteer;
  const FoodRequestsPage({super.key, required this.isVolunteer});

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
    for (var donation in donations) {
      print("requets: " + donation.data()["requesters"].toString());
      //store the donation id in the data map

      if (donation.data()["requesters"] != null) {
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
    }

    setState(() {
      isLoading = false;
    });

    print("Data map: " + data.toString());
  }

  // a fucntion that will get all the users details
  void fetchUsers() {
    print("fetching users");
    FirebaseFirestore.instance.collection('users').get().then((value) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> dat = value.docs;
      if (dat.isNotEmpty) {
        users = dat;
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
    //print(" data[0]: " + data.values.toString());
    //print(" data[0]: " + data.values.first.toString());

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
                  //check if the array of 1st data is empty
                  data.values.first.toString() == "[]"
                      ? const Center(
                          child: Text("You haven't received any requets"))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return FoodRequestWidget(
                                  name: data[donations[index].id][0]["name"],
                                  foodType: donations[index].data()["foodType"],
                                  imgUrl: donations[index].data()["image"],
                                  deleteRequest: () => declineRequest(
                                        requesters[donations[index].id],
                                      ),
                                  chatUser: () => {
                                        chat(requesters[donations[index].id],
                                            donations[index].id)
                                      });
                            },
                          ),
                        ),
                ],
              ),
            ),
    );
  }

  chat(index, donationId) {
    //update the status in requests collection
    FirebaseFirestore.instance
        .collection('requests')
        .where("userId", isEqualTo: requesters[donations[0].id])
        .get()
        .then((value) {
      if (value.docs[0]['status'] != 'accepted') {
        print(value.docs[0].id);
        FirebaseFirestore.instance
            .collection('requests')
            .doc(value.docs[0].id)
            .update({
          "status": "accepted",
        }).then((value) {
          //remove the id from the requesters array in donations collection
        });
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            receiverId: index, //user id
            receiverName: "Chat with Volunteer", //user name
            isVolunteer: widget.isVolunteer,
            donationId: donationId,
          ),
        ),
      );
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils.dart';

class MapGoogle extends StatefulWidget {
  final bool isVolunteer;
  const MapGoogle({super.key, required this.isVolunteer});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapGoogle> {
  late GoogleMapController mapController;
  List<Marker> markers = [];

  bool alreadyRequested = false;

  @override
  void initState() {
    super.initState();
    fetchDonations();
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> donations = [];
  bool isLoading = false;
  bool sending = false;
  void fetchDonations() {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance.collection('donations').get().then((value) {
      print(value.docs);
      List<QueryDocumentSnapshot<Map<String, dynamic>>> dat = value.docs;
      if (dat.isNotEmpty) {
        setState(() {
          donations = dat;
        });

        for (var donation in donations) {
          final latitude = donation.data()['location'].toString().split(',')[0];
          final longitude =
              donation.data()['location'].toString().split(',')[1];
          markers.add(
            Marker(
              markerId: MarkerId(donation.id),
              position: LatLng(
                double.parse(latitude),
                double.parse(longitude),
              ),
              onTap: () async {
                await checkIfAlreadyRequested(
                    donation.id, donation, latitude, longitude);
              },
            ),
          );
        }
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Bank Map'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(32.15567, 74.18705),
                zoom: 13,
              ),
              markers: Set.from(markers),
            ),
    );
  }

  void _showMarkerDetails(CustomMarker marker, isRequested) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 230,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Marker Details',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Name: ${marker.name}',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${marker.description}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16),

              isRequested
                  ? const Text("You have already requested this food")
                  : ElevatedButton(
                      onPressed: () {
                        requestFood(marker);
                      },
                      child: const Text("Request Food")),
              // Add more details or widgets as needed
            ],
          ),
        );
      },
    );
  }

  void requestFood(dontaion) {
    FirebaseFirestore.instance.collection("requests").doc().set({
      "donationId": dontaion.id,
      "userId": FirebaseAuth.instance.currentUser!.uid.toString(),
      "status": "pending",
    }).then((value) {
      //add a requesters field in the donation document to keep track of the requesters
      FirebaseFirestore.instance
          .collection("donations")
          .doc(dontaion.id)
          .update({
        "requesters": FieldValue.arrayUnion(
            [FirebaseAuth.instance.currentUser!.uid.toString()])
      }).then((value) {
        //show a snackbar on top of the screen to show the sucess message

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Requets Sent'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              right: 20,
              left: 20),
        ));

        Navigator.pop(context);
      });
      //show a snackbar to show the sucess message
    });
  }

  //a function that will check if the current user has already requested the food
  Future<void> checkIfAlreadyRequested(
      String donationId, donation, latitude, longitude) {
    setState(() {
      sending = true;
    });
    print("checking if already requested");
    //get the donation document
    FirebaseFirestore.instance
        .collection("donations")
        .doc(donationId)
        .get()
        .then((value) {
      //get the requesters array
      List<dynamic> requesters = value.data()!['requesters'];
      //check if the current user is in the requesters array
      if (requesters.contains(FirebaseAuth.instance.currentUser!.uid)) {
        setState(() {
          alreadyRequested = true;
        });
        print("already requested: $alreadyRequested");
      }
    }).then((value) {
      _showMarkerDetails(
        CustomMarker(
          id: donation.id,
          pictureUrl: donation.data()['image'],
          name: donation.data()['foodType'],
          description:
              "Quantity: ${donation.data()['quantity']}, Date: ${donation.data()['preferredDate']}, Time: ${donation.data()['preferredTime']}",
          latitude: double.parse(latitude),
          longitude: double.parse(longitude),
        ),
        alreadyRequested,
      );
    });

    return Future.value();
  }

  //a function to show the shortest path betweeen 2 locations
  Future<void> showShortestPath() async {
    //get the current location of the user
    //get the location of the donation
    //show the shortest path between the 2 locations

    //get the current location of the user using package
  }
}

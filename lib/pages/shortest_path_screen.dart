import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils.dart';

class ShortestPathScreen extends StatefulWidget {
  final String donationId;
  const ShortestPathScreen({super.key, required this.donationId});

  @override
  State<ShortestPathScreen> createState() => _ShortestPathScreenState();
}

class _ShortestPathScreenState extends State<ShortestPathScreen> {
  late GoogleMapController mapController;
  List<Marker> markers = [];
  var isLoading = false;

  void fetchDonations() {
    print("donation id" + widget.donationId.toString());
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance
        .collection('donations')
        .doc(widget.donationId)
        .get()
        .then((value) {
      print("Status: " + value.data()!['preferredDate']);

      final latitude = value.data()!['location'].toString().split(',')[0];
      final longitude = value.data()!['location'].toString().split(',')[1];
      print("donation lat: " + latitude);
      setState(() {
        markers.add(
          Marker(
            markerId: MarkerId(value.id),
            position: LatLng(
              double.parse(latitude),
              double.parse(longitude),
            ),
            onTap: () {
              _showMarkerDetails(
                CustomMarker(
                  id: value.id,
                  pictureUrl: value.data()!['image'],
                  name: value.data()!['foodType'],
                  description:
                      "Quantity: ${value.data()!['quantity']}, Date: ${value.data()!['preferredDate']}, Time: ${value.data()!['preferredTime']}",
                  latitude: double.parse(latitude),
                  longitude: double.parse(longitude),
                ),
              );
            },
          ),
        );
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDonations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Path to the donation'),
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
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
            ),
    );
  }

  void _showMarkerDetails(CustomMarker marker) {
    print("yo");
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
                'Description: ${marker.description}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16),

              // Add more details or widgets as needed
            ],
          ),
        );
      },
    );
  }
}

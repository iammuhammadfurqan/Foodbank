import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'chatScreen.dart';

class MapGoogle extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapGoogle> {
  late GoogleMapController mapController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    initializeMarkers();
  }

  void initializeMarkers() {
    // Define your markers here
    List<CustomMarker> customMarkers = [
      CustomMarker(
        id: '1',
        pictureUrl: 'https://example.com/marker1.jpg',
        name: 'Marker 1',
        description: 'This is marker 1',
        latitude: 32.15567,
        longitude: 74.18705,
      ),
      CustomMarker(
        id: '2',
        pictureUrl: 'https://example.com/marker2.jpg',
        name: 'Marker 2',
        description: 'This is marker 2',
        latitude: 32.49268000,
        longitude: 74.53134000,
      ),
      CustomMarker(
        id: '3',
        pictureUrl: 'https://example.com/marker2.jpg',
        name: 'Marker 3',
        description:
            'Hello, Sialkot is one of the famoue city of Punjab,Pakistan. It is famous for sprots',
        latitude: 32.334984,
        longitude: 74.53134000,
      ),
      // Add more markers here
    ];

    for (var marker in customMarkers) {
      markers.add(
        Marker(
          markerId: MarkerId(marker.id),
          position: LatLng(marker.latitude, marker.longitude),
          onTap: () {
            _showMarkerDetails(marker);
          },
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _findShortestRoute(
      double destinationLat, double destinationLng) async {
    Position currentPosition = await Geolocator.getCurrentPosition();
    double startLat = currentPosition.latitude;
    double startLng = currentPosition.longitude;

    String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&origin=$startLat,$startLng&destination=$destinationLat,$destinationLng';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Bank Map'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(32.15567, 74.18705),
          zoom: 12.0,
        ),
        markers: Set.from(markers),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Replace the marker position below with the desired marker to find the route to
      //     _findShortestRoute(37.7749, -122.4194);
      //   },
      //   child: Icon(Icons.directions),
      // ),
    );
  }

  void _showMarkerDetails(CustomMarker marker) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 230,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Marker Details',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Name: ${marker.name}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Description: ${marker.description}',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(profileId: marker.id),
                    ),
                  );
                },
                child: Text('Chat'),
              ),
              // Add more details or widgets as needed
            ],
          ),
        );
      },
    );
  }
}

class CustomMarker {
  final String id;
  final String pictureUrl;
  final String name;
  final String description;
  final double latitude;
  final double longitude;

  CustomMarker({
    required this.id,
    required this.pictureUrl,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
  });
}

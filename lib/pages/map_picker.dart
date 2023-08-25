import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPicker extends StatefulWidget {
  static const DEFAULT_ZOOM = 14.4746;

  LatLng? value;
  LatLng? selectedMarkerPosition; // Added to store selected marker position

  MapPicker({
    Key? key,
  }) : super(key: key);

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  final Completer<GoogleMapController> _controller = Completer();

  final initZoom = MapPicker.DEFAULT_ZOOM;
  LatLng initCoordinates = const LatLng(32, 74); // Default initial coordinates

  @override
  void initState() {
    super.initState();
    getCurrentLocation().then((position) {
      setState(() {
        initCoordinates = LatLng(position.latitude, position.longitude);
        print("init coordinates: " + initCoordinates.toString());
      });
    });
  }

  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Handle permission denied
      throw Exception('Location permissions are denied');
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Long press to select a location"),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  var maxWidth = constraints.biggest.width;
                  var maxHeight = constraints.biggest.height;

                  return Stack(
                    children: <Widget>[
                      SizedBox(
                        height: maxHeight,
                        width: maxWidth,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: initCoordinates,
                            zoom: 7,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          onCameraMove: (CameraPosition newPosition) {
                            widget.value = newPosition.target;
                          },
                          onLongPress: (LatLng newPosition) {
                            setState(() {
                              widget.selectedMarkerPosition = newPosition;
                            });
                          },
                          markers: widget.selectedMarkerPosition != null
                              ? {
                                  Marker(
                                    markerId: const MarkerId('selectedMarker'),
                                    position: widget.selectedMarkerPosition!,
                                  ),
                                }
                              : {},
                          mapType: MapType.normal,
                          myLocationButtonEnabled: true,
                          myLocationEnabled: false,
                          zoomGesturesEnabled: true,
                          padding: const EdgeInsets.all(0),
                          buildingsEnabled: true,
                          cameraTargetBounds: CameraTargetBounds.unbounded,
                          compassEnabled: true,
                          indoorViewEnabled: false,
                          mapToolbarEnabled: true,
                          minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                          rotateGesturesEnabled: true,
                          scrollGesturesEnabled: true,
                          tiltGesturesEnabled: true,
                          trafficEnabled: false,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Display the selected marker's position
            if (widget.selectedMarkerPosition != null)
              Text(
                'Selected Marker Position: ${widget.selectedMarkerPosition}',
                style: const TextStyle(fontSize: 18),
              ),
            SizedBox(height: 16),
            // Save Location Button
            ElevatedButton(
              onPressed: widget.selectedMarkerPosition != null
                  ? () {
                      // Save latitude and longitude
                      double latitude = widget.selectedMarkerPosition!.latitude;
                      double longitude =
                          widget.selectedMarkerPosition!.longitude;
                      // Do something with the latitude and longitude values
                      print('Latitude: $latitude, Longitude: $longitude');
                      // Go back to the previous screen (pop)
                      Navigator.pop(
                          context, widget.selectedMarkerPosition.toString());
                    }
                  : null, // Disable button if no marker selected
              child: const Text('Save Location'),
            ),
          ],
        ),
      ),
    );
  }
}

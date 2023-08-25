import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Future<Position?> determinePosition() async {
  //print("determinePosition");
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      await Geolocator.openAppSettings();
      // return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    await Geolocator.openAppSettings();
    //return Future.error(
    //    'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  //print(Geolocator.getCurrentPosition());
  //show a snackar to display the location
  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
    //print latitude and longitude
    print(await Geolocator.getCurrentPosition());

    return await Geolocator.getCurrentPosition();
  }

  //return await Geolocator.getCurrentPosition();
}

String extractLatLng(String input) {
  // Remove "LatLng(" and ")" from the input string
  String cleanInput = input.replaceAll('LatLng(', '').replaceAll(')', '');

  // Split the clean input into latitude and longitude parts
  List<String> parts = cleanInput.split(', ');

  if (parts.length != 2) {
    throw Exception('Invalid input format');
  }

  // Extract latitude and longitude
  double latitude = double.parse(parts[0]);
  double longitude = double.parse(parts[1]);

  return '$latitude,$longitude';
}

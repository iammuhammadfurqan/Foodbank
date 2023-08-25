import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodbank/homeScreen.dart';
import 'package:foodbank/pages/map_picker.dart';
import 'package:foodbank/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class DonationDetailNGO extends StatefulWidget {
  final bool isNGO;
  const DonationDetailNGO({super.key, required this.isNGO});

  @override
  _AddFoodDetailsState createState() => _AddFoodDetailsState();
}

class _AddFoodDetailsState extends State<DonationDetailNGO> {
  File? _image;

  var imgUrl = "";
  var isLoading = false;
  final _locationController = TextEditingController();
  final _foodTypeController = TextEditingController();
  final _preferredTimeController = TextEditingController();
  final _preferredDateController = TextEditingController();
  final _quantityController = TextEditingController();
  final _orgController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    _foodTypeController.dispose();
    _preferredTimeController.dispose();
    _preferredDateController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void resetFields() {
    _locationController.clear();
    _foodTypeController.clear();
    _preferredTimeController.clear();
    _preferredDateController.clear();
    _quantityController.clear();
    _orgController.clear();
    setState(() {
      _image = null;
    });
  }

  Future<void> uploadImage(File imageFile) async {
    final FirebaseStorage _storage = FirebaseStorage.instance;

    if (_image == null) {
      return;
    }

    String imgPath = imageFile.path.split("/").last;
    Reference reference = _storage
        .ref()
        .child("foods/${FirebaseAuth.instance.currentUser?.uid}/$imgPath");
    Task upload = reference.putFile(imageFile);
    await upload.then((v) async {
      String url = await v.ref.getDownloadURL();
      setState(() {
        imgUrl = url;
        print("image url: $imgUrl");
      });
    });

    FirebaseFirestore.instance.collection("donations").add({
      "location": _locationController.text,
      "foodType": _foodTypeController.text,
      "preferredTime": _preferredTimeController.text,
      "preferredDate": _preferredDateController.text,
      "quantity": _quantityController.text,
      "image": imgUrl.toString(),
      "isNGO": widget.isNGO,
      "donator": FirebaseAuth.instance.currentUser!.uid,
      "receiver": "",
      "organization_id":
          _orgController.text.isEmpty ? "" : _orgController.text.toString(),
      "isActive": true,
    }).then((value) {
      setState(() {
        isLoading = false;
      });
      //show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Donation added successfully'),
        ),
      );
      resetFields();

      //dispose();
    }).catchError((error) {
      print(error);
    });
  }

  void saveDonationDetails() {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      uploadImage(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Food Details'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Text(_locationController.text),
                  const Text(
                    'Add Location',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapPicker(),
                        ),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            _locationController.text = extractLatLng(value);
                          });
                        }
                      });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _locationController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a location';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter location details',
                        suffixIcon: Icon(Icons.location_on),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  const Text(
                    'Food Type',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _foodTypeController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a food type';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Fast Food ',
                      suffixIcon: Icon(Icons.food_bank),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  const Text(
                    'Preferred Time',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _preferredTimeController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a preferred time';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: '11:00 AM to 02:00 PM',
                      suffixIcon: Icon(Icons.watch_later_sharp),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  const Text(
                    'Preffered Date',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _preferredDateController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a preferred date';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: '01-Feb-2023',
                      suffixIcon: Icon(Icons.calendar_month_outlined),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  const Text(
                    'Quantity',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _quantityController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a quantity';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: '500 Pieces',
                      suffixIcon: Icon(Icons.format_list_numbered),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (widget.isNGO)
                    const Text(
                      'Organization ID',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  if (widget.isNGO)
                    TextFormField(
                      controller: _orgController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Valid ID';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: '1234567',
                        suffixIcon: Icon(Icons.app_registration_outlined),
                      ),
                    ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Add Photo',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: InkWell(
                      onTap: () {
                        getImage();
                      },
                      child: _image == null
                          ? Container(
                              height: 100.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.8),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 50.0,
                                    color: Colors.grey.withOpacity(0.8),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    'Add Photo',
                                    style: TextStyle(
                                        color: Colors.grey.withOpacity(0.8)),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              height: 150.0,
                              width: 150.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                image: DecorationImage(
                                  image: FileImage(_image!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: ElevatedButton(
                            onPressed: () {
                              saveDonationDetails();
                            },
                            child: const Text(
                              'Donate',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getLocationCoordinatesFromMap() {
    //open map and get coordinates
    //set the coordinates to _locationController
    // _locationController.text = "lat: $lat, long: $long";
  }
  Future<void> openGoogleMaps() async {
    final String mapUrl = 'https://www.google.com/maps';
    if (await canLaunch(mapUrl)) {
      await launch(mapUrl);
    } else {
      throw 'Could not launch $mapUrl';
    }
  }

  Future<Map<String, double>?> getSelectedLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return {
      'latitude': _locationData.latitude!,
      'longitude': _locationData.longitude!,
    };
  }
}

import 'package:flutter/material.dart';
import 'package:foodbank/homeScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DonationDetail extends StatefulWidget {
  @override
  _AddFoodDetailsState createState() => _AddFoodDetailsState();
}

class _AddFoodDetailsState extends State<DonationDetail> {
  File? _image;

  final _locationController = TextEditingController();
  final _foodTypeController = TextEditingController();
  final _preferredTimeController = TextEditingController();
  final _preferredDateController = TextEditingController();
  final _quantityController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Food Details'),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Location',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: _locationController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a location';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter location details',
                      suffixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
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
                    decoration: InputDecoration(
                      hintText: 'Fast Food ',
                      suffixIcon: Icon(Icons.food_bank),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
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
                    decoration: InputDecoration(
                      hintText: '11:00 AM to 02:00 PM',
                      suffixIcon: Icon(Icons.watch_later_sharp),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
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
                    decoration: InputDecoration(
                      hintText: '01-Feb-2023',
                      suffixIcon: Icon(Icons.calendar_month_outlined),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
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
                    decoration: InputDecoration(
                      hintText: 'Enter quantity in Kgs',
                      suffixIcon: Icon(Icons.format_list_numbered),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    'Add Photo',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.0),
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
                                  SizedBox(height: 10.0),
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
                  SizedBox(height: 15.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Save the data to the database
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        }
                      },
                      child: Text(
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
}

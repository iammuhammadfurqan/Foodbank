import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodbank/DonatorProfile.dart';
import 'package:foodbank/donatorProfile.dart';

import 'package:image_picker/image_picker.dart';

class ProfileUpdateScreen extends StatefulWidget {
  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      _image = File(pickedFile!.path);
    });
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    height: 150.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            _pickImage(ImageSource.camera);
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.camera),
                          label: Text('Take Photo'),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            _pickImage(ImageSource.gallery);
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.image),
                          label: Text('Choose from Gallery'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? Icon(
                        Icons.camera_alt,
                        size: 50.0,
                      )
                    : null,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Change Username',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter username',
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Update Password',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter new password',
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Confirm password',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfileUpdateScreen())); // handle update profile action
              },
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

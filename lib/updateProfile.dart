import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  ProfileUpdateScreenState createState() => ProfileUpdateScreenState();
}

class ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  void updateProfile() {}

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
                  builder: (context) => SizedBox(
                    height: 150.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            _pickImage(ImageSource.camera);
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.camera),
                          label: const Text('Take Photo'),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            _pickImage(ImageSource.gallery);
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.image),
                          label: const Text('Choose from Gallery'),
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
                    ? const Icon(
                        Icons.camera_alt,
                        size: 50.0,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Change Username',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter username',
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Update Password',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter new password',
              ),
            ),
            const SizedBox(height: 10.0),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Confirm password',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ProfileUpdateScreen())); // handle update profile action
              },
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

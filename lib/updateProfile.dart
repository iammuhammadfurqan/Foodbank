import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  ProfileUpdateScreenState createState() => ProfileUpdateScreenState();
}

class ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  File? _image;
  var isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  var imgUrl = "";

  Future<void> uploadImage(File imageFile) async {
    setState(() {
      isLoading = true;
    });
    final FirebaseStorage _storage = FirebaseStorage.instance;

    if (_image == null) {
      return;
    }

    String imgPath = imageFile.path.split("/").last;
    Reference reference = _storage
        .ref()
        .child("users/${FirebaseAuth.instance.currentUser?.uid}/$imgPath");
    Task upload = reference.putFile(imageFile);
    await upload.then((v) async {
      String url = await v.ref.getDownloadURL();
      setState(() {
        imgUrl = url;
        print("image url: $imgUrl");
      });
    });

    //update the document with the image url
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'imgUrl': imgUrl}).then((value) {
      //show a snackbar to show that the profile has been updated
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile Updated'),
        ),
      );
      setState(() {
        isLoading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
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
            ElevatedButton(
              onPressed: () async {
                await uploadImage(_image!);
              },
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

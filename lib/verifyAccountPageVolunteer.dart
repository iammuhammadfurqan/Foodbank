import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:foodbank/loginPageReceiver.dart';
import './LoginPage.dart';

class VerifyAccountPageVolunteer extends StatefulWidget {
  const VerifyAccountPageVolunteer({Key? key}) : super(key: key);

  @override
  _VerifyAccountPageState createState() => _VerifyAccountPageState();
}

class _VerifyAccountPageState extends State<VerifyAccountPageVolunteer> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    // Get the list of available cameras and select the first one
    availableCameras().then((cameras) {
      _controller = CameraController(cameras[0], ResolutionPreset.medium);

      // Initialize the camera controller
      _initializeControllerFuture = _controller.initialize();
    });
  }

  @override
  void dispose() {
    // Dispose of the camera controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // TODO: Navigate back to previous screen
          },
        ),
        title: const Text('Volunteer Verification'),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 85),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Verify Account',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () async {
                // Take a picture using the camera controller
                await _initializeControllerFuture;
                final image = await _controller.takePicture();

                // TODO: Save the image or do something else with it
              },
              child: const CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.camera_alt,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                // Take a picture using the camera controller
                await _initializeControllerFuture;
                final image = await _controller.takePicture();

                // TODO: Save the image or do something else with it
              },
              child: const Text('Add Picture'),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () async {
                // Take a picture using the camera controller
                await _initializeControllerFuture;
                final image = await _controller.takePicture();

                // TODO: Save the image or do something else with it
              },
              child: const CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.credit_card_rounded,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                // Take a picture using the camera controller
                await _initializeControllerFuture;
                final image = await _controller.takePicture();

                // TODO: Save the image or do something else with it
              },
              child: const Text('Add ID Card Picture'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginPageReceiver())); // TODO: Verify the account
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './confirmPassword.dart';

class PasswordVerification extends StatelessWidget {
  const PasswordVerification({super.key});

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
        title: const Text("Verification"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Verification',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Enter Code',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'We have sent you a four digits code to your email!',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDigitBox(),
                _buildDigitBox(),
                _buildDigitBox(),
                _buildDigitBox(),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Didn't Receive Code?",
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(width: 5.0),
                GestureDetector(
                  onTap: () {
                    // handle resend code action
                  },
                  child: const Text(
                    'Resend',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ConfirmPassword()));
                },
                child: const Text('Verify Email'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitBox() {
    return Container(
      width: 50.0,
      height: 50.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.black),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        maxLengthEnforcement: MaxLengthEnforcement.none,
        maxLength: 1,
        onChanged: (value) {
          // handle digit input
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './confirmPassword.dart';

class PasswordVerificationReceiver extends StatelessWidget {
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
        title: Text("Verification"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Verification',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Enter Code',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'We have sent you a four digits code to your email!',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDigitBox(),
                _buildDigitBox(),
                _buildDigitBox(),
                _buildDigitBox(),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't Receive Code?",
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(width: 5.0),
                GestureDetector(
                  onTap: () {
                    // handle resend code action
                  },
                  child: Text(
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
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConfirmPassword()));
                },
                child: Text('Verify Email'),
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
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.black),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
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

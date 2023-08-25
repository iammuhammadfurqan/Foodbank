import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationCode = '';

  Future<void> _sendVerificationCode() async {
    final String email = _emailController.text.trim();
    try {
      final String verificationCode = _generateCode();
      final String emailContent =
          'Your verification code is: $verificationCode';
      await _auth.sendPasswordResetEmail(email: email);
      setState(() {
        _verificationCode = verificationCode;
      });
      final emailSentDialog = AlertDialog(
        title: const Text('Email sent'),
        content: Text('A password reset email has been sent to $email'),
      );
      await showDialog(context: context, builder: (ctx) => emailSentDialog);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        final errorDialog = AlertDialog(
          title: const Text('User not found'),
          content: Text('No user found for email $email'),
        );
        await showDialog(context: context, builder: (ctx) => errorDialog);
      } else {
        const errorDialog = AlertDialog(
          title: Text('Error'),
          content:
              Text('An error occurred while sending the password reset email.'),
        );
        await showDialog(context: context, builder: (ctx) => errorDialog);
      }
    }
  }

  String _generateCode() {
    final random = Random();
    return '${random.nextInt(9000) + 1000}'; // generate 4-digit code
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ...
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await _sendVerificationCode();
                }
              },
              child: const Text('Send Verification Code'),
            ),
            const SizedBox(height: 24),
            Text(_verificationCode.isEmpty
                ? ''
                : 'Verification Code: $_verificationCode'),
            // ...
          ],
        ),
      ),
    );
  }
}

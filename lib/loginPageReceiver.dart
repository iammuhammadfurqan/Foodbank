import 'package:flutter/material.dart';
import 'package:foodbank/createPageReceiver.dart';
import 'package:foodbank/homeScreenVolunteer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'forgetPasswordVolunteer.dart';

class LoginPageReceiver extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageReceiver> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  String _email = '';
  String _password = '';

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();

      try {
        if (_emailController.text.isNotEmpty &&
            _passController.text.isNotEmpty) {
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passController.text,
          );

          if (userCredential.user != null) {
            final CollectionReference usersCollection =
                FirebaseFirestore.instance.collection('users');

            DocumentSnapshot userSnapshot =
                await usersCollection.doc(userCredential.user!.uid).get();

            if (userSnapshot.exists) {
              // user exists in Firestore, navigate to home screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreenVolunteer()),
              );
            } else {
              // user doesn't exist in Firestore, show error message
              print('No user found for that email in Firestore.');
            }
          }
        } else {
          print('Email or password cannot be empty');
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        } else {
          print('Error occurred during sign in: $e');
        }
      } catch (e) {
        print('Error occurred during sign in: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome Back!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Image.asset(
                    'assets/images/login.png',
                    height: 150.0,
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.amber,
                                width: 1,
                              ),
                            ),
                            child: Form(
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Enter your Email',
                                  prefixIcon: Icon(Icons.email),
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 16),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _email = value!;
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.amber,
                                width: 1,
                              ),
                            ),
                            child: TextFormField(
                              controller: _passController,
                              decoration: InputDecoration(
                                labelText: 'Enter your Password',
                                prefixIcon: Icon(Icons.lock),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _password = value!;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordVolunteer(),
                        ),
                      ); // Handle forgot password link tapped
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFFF9990A),
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                    width: 250,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreatePageReceiver()));
                          // Handle sign up link tapped
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Color(0xFFF9990A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../verifyAccountPage.dart';
import '../LoginPage.dart';

class CreatePage extends StatefulWidget {
  final String userType;
  const CreatePage({Key? key, required this.userType}) : super(key: key);

  @override
  CreatePageState createState() => CreatePageState();
}

class CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final String alreadyHaveAccountText = 'Already have an account? ';
  var isLoading = false;
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();

    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // a function to create a new user
  Future<void> _createUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      // if the user is created successfully
      if (userCredential.user != null) {
        // add the user data to firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': _nameController.text,
          'email': _emailController.text,
          'number': _numberController.text,
          'userType': widget.userType,
          "createdAt": FieldValue.serverTimestamp(),
        }).then((value) {
          // navigate to verify account page

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The password provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The account already exists for that email.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occured, please try again')));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous screen
          },
        ),
        title: const Text('Donator Signup'),
      ),
      body: Container(
        margin: const EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Create New Account',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_2_sharp),
                      hintText: 'Enter your Name',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(25.0), // Set border radius
                        borderSide:
                            const BorderSide(width: 1.0), // Set border width
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      } else if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(25.0), // Set border radius
                        borderSide:
                            const BorderSide(width: 1.0), // Set border width
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone),
                      hintText: 'Enter your Number',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(25.0), // Set border radius
                        borderSide:
                            const BorderSide(width: 1.0), // Set border width
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_rounded),
                      hintText: 'Enter your Password',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(25.0), // Set border radius
                        borderSide:
                            const BorderSide(width: 1.0), // Set border width
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      } else if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_rounded),
                      hintText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(25.0), // Set border radius
                        borderSide:
                            const BorderSide(width: 1.0), // Set border width
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_confirmPasswordController.text ==
                                  _passwordController.text) {
                                if (_formKey.currentState!.validate()) {
                                  await _createUser();
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Passwords do not match')));
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Text(
                                'Create Account',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        alreadyHaveAccountText,
                        style: const TextStyle(fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
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

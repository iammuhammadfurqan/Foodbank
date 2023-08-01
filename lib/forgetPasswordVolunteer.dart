import 'package:flutter/material.dart';
import 'package:foodbank/createPageReceiver.dart';
import 'package:foodbank/passwordVerificationVolunteer.dart';
import "./passwordVerificationCode.dart";
import 'createPage.dart';

class ForgotPasswordVolunteer extends StatefulWidget {
  const ForgotPasswordVolunteer({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordVolunteer> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Back'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Forget Password',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: TextFormField(
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
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PasswordVerificationReceiver(),
                    ),
                  );
                }
              },
              child: Text('Generate Code'),
            ),
            SizedBox(height: 24),
            Text('or'),
            SizedBox(height: 24),
            Column(
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreatePageReceiver()));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      'Sign up',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

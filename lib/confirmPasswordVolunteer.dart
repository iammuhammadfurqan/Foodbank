import 'package:flutter/material.dart';

class ConfirmPasswordReceiver extends StatefulWidget {
  @override
  _ConfirmPasswordState createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPasswordReceiver> {
  final _formKey = GlobalKey<FormState>();
  late String _password;

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
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Password',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Enter New Password',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              _buildPasswordField(),
              SizedBox(height: 20.0),
              Text(
                'Confirm Password',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              _buildConfirmPasswordField(),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // handle change password action
                      print('Password changed');
                    }
                  },
                  child: Text('Change Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.black),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a password';
          }
          _password = value;
          return _validatePassword();
        },
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.black),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter confirm password';
          }
          if (value != _password) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }

  String? _validatePassword() {
    if (_password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }
}

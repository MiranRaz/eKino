import 'package:ekino_mobile/main.dart';
import 'package:ekino_mobile/screens/ratings_list_screen.dart';
import 'package:ekino_mobile/screens/reservations_my_list_screen.dart';
import 'package:ekino_mobile/screens/upcoming_screen.dart';
import 'package:ekino_mobile/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ekino_mobile/providers/users_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ChangePasswordScreen({super.key, required this.userData});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  late UsersProvider _usersProvider;

  @override
  void initState() {
    super.initState();
    _usersProvider = context.read<UsersProvider>();

    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() async {
    // Get the new password and confirm password
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Update the userData object with the new passwords
    Map<String, dynamic> updatedUserData = Map.from(widget.userData);
    updatedUserData['password'] = newPassword;
    updatedUserData['passwordConfirm'] = confirmPassword;

    try {
      // Implement saving logic here
      print("Saving user data: $updatedUserData");
      await _usersProvider.update(updatedUserData['userId'], updatedUserData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User data updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
      // Navigate back to login after changing the password
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyMaterialApp()),
        (route) => false,
      );
    } catch (error) {
      print('Error saving user data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update user data'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'New Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _changePassword();
                  }
                },
                child: Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

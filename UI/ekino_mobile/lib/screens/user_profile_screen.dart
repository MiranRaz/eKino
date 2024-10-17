import 'package:ekino_mobile/screens/change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ekino_mobile/models/role.dart';
import 'package:ekino_mobile/models/search_result.dart';
import 'package:ekino_mobile/models/user.dart';
import 'package:ekino_mobile/providers/role_provider.dart';
import 'package:ekino_mobile/providers/users_provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late UsersProvider _usersProvider;
  late final RoleProvider _roleProvider = RoleProvider();

  SearchResult<Role>? _roleResult;
  bool _isLoading = true;
  int? _selectedRoleId;
  String? usernameLS;
  Users? _user;
  late Map<String, dynamic> userData;

  Future<String?> _retrieveAndPrintUsernameState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usernameState = prefs.getString('usernameState');
    return usernameState;
  }

  @override
  void initState() {
    super.initState();
    _usersProvider = context.read<UsersProvider>();
    _retrieveAndPrintUsernameState().then((username) {
      setState(() {
        usernameLS = username;
      });
      _fetchUserByUsername(username);
    });
  }

  Future<void> _fetchUserByUsername(String? username) async {
    if (username != null && _isLoading) {
      try {
        final user = await _usersProvider.get(filter: {"Username": username});
        if (user.result.isNotEmpty) {
          setState(() {
            _user = user.result[0];
            userData = {
              "userId": _user?.userId ?? '',
              "firstName": _user?.firstName ?? '',
              "lastName": _user?.lastName ?? '',
              "email": _user?.email ?? '',
              "phone": _user?.phone ?? '',
              "username": _user?.username ?? '',
              "status": _user?.status ?? '',
              "roleIdList": [2]
            };
          });
        }
      } catch (error) {
        print('Error fetching user data: $error');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _updateUserData(String field, String? value) {
    if (value != null) {
      setState(() {
        userData[field] = value;
      });
    }
  }

  void _saveUserData(BuildContext context) async {
    try {
      // Implement saving logic here
      print("Saving user data: $userData");
      await _usersProvider.update(userData['userId'], userData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User data updated successfully'),
          duration: Duration(seconds: 2),
        ),
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
        title: Text('Your Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildForm(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ChangePasswordScreen(userData: userData),
                    ),
                  );
                },
                child: Text('Change Password'),
              ),
              ElevatedButton(
                onPressed: () => _saveUserData(context),
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'firstName',
            decoration: InputDecoration(labelText: 'First Name'),
            initialValue: userData['firstName'] ?? '',
            onChanged: (value) => _updateUserData('firstName', value),
          ),
          FormBuilderTextField(
            name: 'lastName',
            decoration: InputDecoration(labelText: 'Last Name'),
            initialValue: userData['lastName'] ?? '',
            onChanged: (value) => _updateUserData('lastName', value),
          ),
          FormBuilderTextField(
            name: 'username',
            decoration: InputDecoration(labelText: 'Username'),
            initialValue: userData['username'] ?? '',
            onChanged: (value) => _updateUserData('username', value),
          ),
          FormBuilderTextField(
            name: 'email',
            decoration: InputDecoration(labelText: 'Email'),
            initialValue: userData['email'] ?? '',
            onChanged: (value) => _updateUserData('email', value),
          ),
          FormBuilderTextField(
            name: 'phone',
            decoration: InputDecoration(labelText: 'Phone'),
            initialValue: userData['phone'] ?? '',
            onChanged: (value) => _updateUserData('phone', value),
          ),
        ],
      ),
    );
  }
}

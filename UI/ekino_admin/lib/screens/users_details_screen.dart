import 'package:ekino_admin/models/role.dart';
import 'package:ekino_admin/models/search_result.dart';
import 'package:ekino_admin/models/user.dart';
import 'package:ekino_admin/providers/role_provider.dart';
import 'package:ekino_admin/providers/users_provider.dart';
import 'package:ekino_admin/screens/users_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class UserDetailsScreen extends StatefulWidget {
  final Users? user;

  const UserDetailsScreen({Key? key, this.user}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late UsersProvider _usersProvider;
  late RoleProvider _roleProvider = RoleProvider();

  SearchResult<Role>? _roleResult;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _usersProvider = context.read<UsersProvider>();

    _initData().then((_) {
      setState(() {
        _isLoading = false;
      });
    });

    if (widget.user != null) {
      _formKey.currentState?.patchValue({
        'firstName': widget.user!.firstName,
        'lastName': widget.user!.lastName,
        'username': widget.user!.username,
        'status': widget.user!.status?.toString(),
        'email': widget.user!.email,
        'phone': widget.user!.phone,
      });
    }
  }

  Future<void> _initData() async {
    _roleResult = await _roleProvider.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user != null ? 'User Details' : 'New User'),
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
          ),
          FormBuilderTextField(
            name: 'lastName',
            decoration: InputDecoration(labelText: 'Last Name'),
          ),
          FormBuilderTextField(
            name: 'username',
            decoration: InputDecoration(labelText: 'Username'),
          ),
          FormBuilderTextField(
            name: 'email',
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          FormBuilderTextField(
            name: 'phone',
            decoration: InputDecoration(labelText: 'Phone'),
          ),
          FormBuilderTextField(
            name: 'password',
            decoration: InputDecoration(labelText: 'Password'),
          ),
          FormBuilderTextField(
            name: 'passwordConfirmation',
            decoration: InputDecoration(labelText: 'Confirm Password'),
          ),
          FormBuilderDropdown<bool>(
            name: 'status',
            decoration: InputDecoration(labelText: 'Status'),
            items: [
              DropdownMenuItem(
                value: true,
                child: Text('Active'),
              ),
              DropdownMenuItem(
                value: false,
                child: Text('Inactive'),
              ),
            ],
          ),
          FormBuilderDropdown<int>(
            name: 'roleIdList',
            decoration: InputDecoration(labelText: 'Role'),
            items: _roleResult?.result
                    ?.map((role) => DropdownMenuItem(
                          value: role.roleId!,
                          child: Text(role.name ?? ''),
                        ))
                    .toList() ??
                [],
          ),
          ElevatedButton(
            onPressed: _saveUser,
            child: Text(widget.user != null ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveUser() async {
    _formKey.currentState?.save();
    final formData = _formKey.currentState?.value;
    if (formData != null) {
      // Perform validation
      if (!_formKey.currentState!.validate()) {
        return; // Stop execution if there are validation errors
      }

      // Convert formData to modifiable map
      Map<String, dynamic> updatedData =
          Map<String, dynamic>.from(formData ?? {});
      // Ensure roleIdList is always in an array format
      if (updatedData['roleIdList'] != null &&
          !(updatedData['roleIdList'] is List)) {
        updatedData['roleIdList'] = [updatedData['roleIdList']];
      }
      // Ensure string fields are properly formatted
      updatedData['firstName'] = updatedData['firstName'].toString();
      updatedData['lastName'] = updatedData['lastName'].toString();
      updatedData['username'] = updatedData['username'].toString();
      updatedData['email'] = updatedData['email'].toString();
      updatedData['phone'] = updatedData['phone'].toString();
      updatedData['password'] = updatedData['password'].toString();
      updatedData['passwordConfirmation'] =
          updatedData['passwordConfirmation'].toString();
      print('Final data to be sent to the database: $updatedData');
      try {
        if (widget.user != null) {
          await _usersProvider.update(widget.user!.userId!, updatedData);
          _showMessageDialog('Success', 'User updated successfully.');
        } else {
          await _usersProvider.insert(updatedData);
          _showMessageDialog('Success', 'New user added successfully.');
        }
      } catch (error) {
        _showMessageDialog('Error', 'An error occurred: $error');
      }
    }
  }

  Future<void> _showMessageDialog(String title, String message) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (title.contains('Success')) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => UsersListScreen(),
                    ),
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

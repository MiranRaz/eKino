import 'package:ekino_admin/models/role.dart';
import 'package:ekino_admin/models/search_result.dart';
import 'package:ekino_admin/models/user.dart';
import 'package:ekino_admin/providers/role_provider.dart';
import 'package:ekino_admin/providers/users_provider.dart';
import 'package:ekino_admin/screens/users_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int? _selectedRoleId;
  String? usernameLS;

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
    });

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
    try {
      _roleResult = await _roleProvider.get();
      // Set the initial value of roleIdList based on user's role
      if (widget.user != null && widget.user!.roleNames != null) {
        final selectedRole = _roleResult?.result.firstWhere(
          (role) => role.name == widget.user!.roleNames,
        );
        setState(() {
          _selectedRoleId =
              selectedRole?.roleId; // Use selectedRole?.roleId to handle null
        });
      }
    } catch (error) {
      print('Error initializing data: $error');
    }
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
    bool isEditMode = widget.user != null;
    bool showPasswordFields = isEditMode && widget.user?.username == usernameLS;

    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'firstName',
            decoration: InputDecoration(labelText: 'First Name'),
            initialValue: widget.user?.firstName ?? '',
            enabled: showPasswordFields || !isEditMode,
          ),
          FormBuilderTextField(
            name: 'lastName',
            decoration: InputDecoration(labelText: 'Last Name'),
            initialValue: widget.user?.lastName ?? '',
            enabled: showPasswordFields || !isEditMode,
          ),
          FormBuilderTextField(
              name: 'username',
              decoration: InputDecoration(labelText: 'Username'),
              initialValue: widget.user?.username ?? '',
              enabled: showPasswordFields || !isEditMode),
          FormBuilderTextField(
            name: 'email',
            decoration: InputDecoration(labelText: 'Email'),
            initialValue: widget.user?.email ?? '',
            enabled: showPasswordFields ||
                !isEditMode, // Enable if in edit mode or creating new user
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
              initialValue: widget.user?.phone ?? '',
              enabled: showPasswordFields ||
                  !isEditMode // Enable if in edit mode or creating new user
              ),
          if (showPasswordFields || !isEditMode) ...[
            FormBuilderTextField(
              name: 'password',
              decoration: InputDecoration(labelText: 'Password'),
              enabled: !isEditMode ||
                  showPasswordFields, // Enable if not in edit mode or if showPasswordFields is true
            ),
            FormBuilderTextField(
              name: 'passwordConfirmation',
              decoration: InputDecoration(labelText: 'Confirm Password'),
              enabled: !isEditMode ||
                  showPasswordFields, // Enable if not in edit mode or if showPasswordFields is true
            ),
          ],
          FormBuilderDropdown<bool>(
            name: 'status',
            decoration: InputDecoration(labelText: 'Status'),
            initialValue: widget.user?.status,
            items: const [
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
            initialValue: _selectedRoleId,
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

      // Only include password fields if they are not empty
      if (updatedData['password'] != null &&
          updatedData['password'].isNotEmpty) {
        updatedData['password'] = updatedData['password'].toString();
      } else {
        updatedData.remove('password');
      }
      if (updatedData['passwordConfirmation'] != null &&
          updatedData['passwordConfirmation'].isNotEmpty) {
        updatedData['passwordConfirmation'] =
            updatedData['passwordConfirmation'].toString();
      } else {
        updatedData.remove('passwordConfirmation');
      }

      try {
        if (widget.user != null) {
          // If widget.user is not null, update the existing user
          await _usersProvider.update(widget.user!.userId!, updatedData);
          _showMessageDialog('Success', 'User updated successfully.');
        } else {
          // If widget.user is null, insert the new user

          // Check if username already exists
          if (await _usersProvider
              .checkUsernameExists(updatedData['username'])) {
            _showMessageDialog('Error', 'Username already exists.');
            return;
          }

          // Check if email already exists
          if (await _usersProvider.checkEmailExists(updatedData['email'])) {
            _showMessageDialog('Error', 'Email already exists.');
            return;
          }

          // Check if phone already exists
          if (await _usersProvider.checkPhoneExists(updatedData['phone'])) {
            _showMessageDialog('Error', 'Phone already exists.');
            return;
          }

          await _usersProvider.insert(updatedData);
          _showMessageDialog('Success', 'New user added successfully.');
        }

        // Reset the form after successful submission
        _formKey.currentState?.reset();
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

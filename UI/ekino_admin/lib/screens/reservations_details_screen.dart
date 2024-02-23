import 'package:ekino_admin/models/projection.dart';
import 'package:ekino_admin/models/reservation.dart';
import 'package:ekino_admin/models/user.dart';
import 'package:ekino_admin/providers/projections_provider.dart';
import 'package:ekino_admin/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ReservationDetailsScreen extends StatefulWidget {
  final Reservation? reservation;

  const ReservationDetailsScreen({Key? key, this.reservation})
      : super(key: key);

  @override
  State<ReservationDetailsScreen> createState() =>
      _ReservationDetailsScreenState();
}

class _ReservationDetailsScreenState extends State<ReservationDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late Map<String, dynamic> _initialValue;
  late UsersProvider _usersProvider;
  late ProjectionsProvider _projectionsProvider;
  List<Users>? _usersList;
  List<Projection>? _projectionsList;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      "userId": widget.reservation?.userId?.toString(),
      "projectionId": widget.reservation?.projectionId.toString(),
      "row": widget.reservation?.row ?? '',
      "column": widget.reservation?.column ?? '',
      "numTickets": widget.reservation?.numTickets ?? '',
    };

    _usersProvider = context.read<UsersProvider>();
    _projectionsProvider = context.read<ProjectionsProvider>();
    initForm();
  }

  Future<void> initForm() async {
    final usersResult = await _usersProvider.get();
    _usersList = usersResult.result;
    final projectionsResult = await _projectionsProvider.get();
    _projectionsList = projectionsResult.result;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reservation != null
            ? 'Reservation Details'
            : 'New Reservation'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading ? CircularProgressIndicator() : _buildForm(),
      ),
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          FormBuilderDropdown<String>(
            name: 'userId',
            decoration: InputDecoration(labelText: "User"),
            items: _usersList
                    ?.map((user) => DropdownMenuItem(
                          value: user.userId.toString(),
                          child: Text(user.username ?? ''),
                        ))
                    .toList() ??
                [],
          ),
          FormBuilderDropdown<String>(
            name: 'projectionId',
            decoration: InputDecoration(labelText: "Projection"),
            items: _projectionsList
                    ?.map(
                      (projection) => DropdownMenuItem(
                        value: projection.projectionId.toString(),
                        child: Text(projection.movie?.title ?? ''),
                      ),
                    )
                    .toList() ??
                [],
          ),
          FormBuilderTextField(
            name: 'row',
            decoration: InputDecoration(labelText: "Row"),
          ),
          FormBuilderTextField(
            name: 'column',
            decoration: InputDecoration(labelText: "Column"),
          ),
          FormBuilderTextField(
            name: 'numTickets',
            decoration: InputDecoration(labelText: "Number of Tickets"),
          ),
          ElevatedButton(
            onPressed: () async {
              _formKey.currentState?.save();
              final formData = _formKey.currentState?.value;
              if (formData != null) {
                try {
                  await _saveReservation(formData);
                } catch (error) {
                  print('Error: $error');
                  _showMessageDialog('Error', 'An error occurred: $error');
                }
              }
            },
            child: Text(widget.reservation != null ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveReservation(Map<String, dynamic> formData) async {}

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
                  Navigator.of(context).pop();
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

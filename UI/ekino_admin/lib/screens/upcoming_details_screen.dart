import 'package:ekino_admin/models/auditorium.dart';
import 'package:ekino_admin/models/movies.dart';
import 'package:ekino_admin/providers/auditorium_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:ekino_admin/models/projection.dart';
import 'package:ekino_admin/providers/projections_provider.dart';
import 'package:ekino_admin/providers/movies_provider.dart';
import 'package:intl/intl.dart';

class ProjectionDetailsScreen extends StatefulWidget {
  final Projection? projection;

  const ProjectionDetailsScreen({Key? key, this.projection}) : super(key: key);

  @override
  State<ProjectionDetailsScreen> createState() =>
      _ProjectionDetailsScreenState();
}

class _ProjectionDetailsScreenState extends State<ProjectionDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late Map<String, dynamic> _initialValue;
  late ProjectionsProvider _projectionsProvider;
  late MoviesProvider _moviesProvider;
  late AuditoriumProvider _auditoriumProvider;
  List<Movies>? _moviesList;
  List<Auditorium>? _auditoriumList;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      "dateOfProjection": widget.projection?.dateOfProjection ?? DateTime.now(),
      "movieId": widget.projection?.movie?.movieId.toString(),
      "auditoriumId": widget.projection?.auditoriumId.toString(),
      "ticketPrice": widget.projection?.ticketPrice.toString(),
    };

    _projectionsProvider = context.read<ProjectionsProvider>();
    _moviesProvider = context.read<MoviesProvider>();
    _auditoriumProvider = context.read<AuditoriumProvider>();
    initForm();
  }

  Future<void> initForm() async {
    final moviesResult = await _moviesProvider.get();
    _moviesList = moviesResult.result;
    final auditoriumResult = await _auditoriumProvider.get();
    _auditoriumList = auditoriumResult.result;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projection != null
            ? 'Projection Details'
            : 'New Projection'),
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
          FormBuilderDateTimePicker(
            name: 'dateOfProjection',
            decoration: InputDecoration(labelText: "Date of Projection"),
            inputType: InputType.both,
            format: DateFormat('yyyy-MM-dd HH:mm'),
          ),
          FormBuilderDropdown<String>(
            name: 'movieId',
            decoration: InputDecoration(labelText: "Movie"),
            items: _moviesList
                    ?.map((movie) => DropdownMenuItem(
                          value: movie.movieId.toString(),
                          child: Text(movie.title ?? ''),
                        ))
                    .toList() ??
                [],
          ),
          FormBuilderDropdown<String>(
            name: 'auditoriumId',
            decoration: InputDecoration(labelText: "Auditorium"),
            items: _auditoriumList
                    ?.map(
                      (auditorium) => DropdownMenuItem(
                        value: auditorium.auditoriumId.toString(),
                        child: Text(auditorium.name ?? ''),
                      ),
                    )
                    .toList() ??
                [],
          ),
          FormBuilderTextField(
            name: 'ticketPrice',
            decoration: InputDecoration(labelText: "Ticket Price"),
          ),
          ElevatedButton(
            onPressed: () async {
              _formKey.currentState?.save();
              final formData = _formKey.currentState?.value;
              if (formData != null) {
                try {
                  await _saveProjection(formData);
                } catch (error) {
                  print('Error: $error');
                  _showMessageDialog('Error', 'An error occurred: $error');
                }
              }
            },
            child: Text(widget.projection != null ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveProjection(Map<String, dynamic> formData) async {
    // Convert movieId, auditoriumId, and ticketPrice to the correct type
    final int? movieId = formData['movieId'] != null
        ? int.tryParse(formData['movieId'].toString())
        : null;
    final int? auditoriumId = formData['auditoriumId'] != null
        ? int.tryParse(formData['auditoriumId'].toString())
        : null;
    final double? ticketPrice = formData['ticketPrice'] != null
        ? double.tryParse(formData['ticketPrice'].toString())
        : null;

    // Retrieve dateOfProjection directly as DateTime
    final DateTime? dateOfProjection = formData['dateOfProjection'];

    // Check if the parsed values are not null
    if (movieId != null &&
        auditoriumId != null &&
        ticketPrice != null &&
        dateOfProjection != null) {
      final String iso8601DateOfProjection = dateOfProjection.toIso8601String();

      // Create a map to represent the projection data
      final Map<String, dynamic> projectionData = {
        'dateOfProjection': iso8601DateOfProjection,
        'movieId': movieId,
        'auditoriumId': auditoriumId,
        'ticketPrice': ticketPrice,
      };
      print('FormData before saving:');
      projectionData.forEach((key, value) {
        print('$key: $value (${value.runtimeType})');
      });

      try {
        // Insert or update the projection using the ProjectionsProvider
        if (widget.projection != null) {
          // Update the existing projection
          await _projectionsProvider.update(
              widget.projection!.projectionId!, projectionData);
          _showMessageDialog('Success', 'Projection updated successfully.');
        } else {
          // Insert a new projection
          await _projectionsProvider.insert(projectionData);
          _showMessageDialog('Success', 'New projection added successfully.');
        }
      } catch (error) {
        print('Error while saving projection: $error');
        _showMessageDialog('Error', 'An error occurred: $error');
      }
    } else {
      print('Invalid data format!');
      _showMessageDialog('Error', 'Invalid data format!');
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

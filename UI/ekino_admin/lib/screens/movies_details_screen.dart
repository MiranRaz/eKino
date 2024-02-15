import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:ekino_admin/models/directors.dart';
import 'package:ekino_admin/models/movies.dart';
import 'package:ekino_admin/models/search_result.dart';
import 'package:ekino_admin/providers/directors_provider.dart';
import 'package:ekino_admin/providers/movies_provider.dart';
import 'package:ekino_admin/widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class MoviesDetailsScreen extends StatefulWidget {
  final Movies? movies;

  const MoviesDetailsScreen({Key? key, this.movies}) : super(key: key);

  @override
  State<MoviesDetailsScreen> createState() => _MoviesDetailsScreenState();
}

class _MoviesDetailsScreenState extends State<MoviesDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late Map<String, dynamic> _initialValue;
  late MoviesProvider _moviesProvider;
  late DirectorsProvider _directorsProvider;
  SearchResult<Director>? directorResult;
  bool isLoading = true;
  String? _base64Image;

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
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initialValue = Map.from({
      "title": widget.movies?.title,
      "description": widget.movies?.description,
      "year": widget.movies?.year,
      "runningTime": widget.movies?.runningTime,
      "photo": widget.movies?.photo,
      "directorId": widget.movies?.directorId?.toString(),
    });

    _directorsProvider = context.read<DirectorsProvider>();
    _moviesProvider = context.read<MoviesProvider>();
    initForm();
  }

  Future<void> initForm() async {
    directorResult = await _directorsProvider.get();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movies?.title ?? 'New Movie'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child:
                  isLoading ? const CircularProgressIndicator() : _buildForm(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _getImagePreview(),
                    _buildImagePicker(),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        _formKey.currentState?.saveAndValidate();
                        final updatedData = _formKey.currentState?.value;
                        if (updatedData != null) {
                          try {
                            if (widget.movies != null) {
                              // Format the year to a string before updating
                              updatedData['year'] =
                                  _formatDateTime(updatedData['year']);
                              await _moviesProvider.update(
                                  widget.movies!.movieId!, updatedData);
                              _showMessageDialog(
                                  'Success', 'Movie updated successfully.');
                            } else {
                              // Insert logic
                              final newMovie =
                                  await _moviesProvider.insert(updatedData);
                              _showMessageDialog('Success',
                                  'New movie added successfully with ID: ${newMovie.movieId}');
                            }
                          } catch (error) {
                            _showMessageDialog(
                                'Error', 'An error occurred: $error');
                          }
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'title',
            decoration: InputDecoration(labelText: "Title"),
          ),
          FormBuilderTextField(
            name: 'description',
            decoration: InputDecoration(labelText: "Description"),
            maxLines: 5,
          ),
          FormBuilderDateTimePicker(
            name: 'year',
            decoration: InputDecoration(labelText: "Year"),
            inputType: InputType.date,
            format: DateFormat('yyyy-MM-dd'),
          ),
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: 'runningTime',
                  decoration: InputDecoration(labelText: "Running Time"),
                ),
              ),
            ],
          ),
          FormBuilderDropdown<String>(
            name: 'directorId',
            decoration: InputDecoration(labelText: "Director"),
            items: directorResult?.result.map((x) {
                  return DropdownMenuItem(
                    value: x.directorId.toString(),
                    child: Text(x.fullName ?? ""),
                  );
                }).toList() ??
                [],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return FormBuilderField(
      name: "photo",
      builder: (field) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: "Choose a picture",
            errorText: field.errorText,
          ),
          child: ListTile(
            leading: const Icon(Icons.photo),
            title: const Text("Select image"),
            trailing: const Icon(Icons.file_upload),
            onTap: _getImage,
          ),
        );
      },
    );
  }

  Widget _getImagePreview() {
    final String? base64Image =
        _formKey.currentState?.value['photo'] as String?;
    if (base64Image != null) {
      return Container(
        width: double.infinity,
        height: 400,
        child: Image.memory(base64Decode(base64Image)),
      );
    } else if (widget.movies?.photo != null) {
      return Container(
        width: double.infinity,
        height: 400,
        child: Image.memory(base64Decode(widget.movies!.photo!)),
      );
    }
    return const Placeholder();
  }

  File? _image;

  Future<void> _getImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      final newImage = File(result.files.single.path!);
      final newBase64Image = base64Encode(newImage.readAsBytesSync());

      setState(() {
        _image = newImage;
        _base64Image = newBase64Image;
        _initialValue['photo'] = newBase64Image; // Update the initial value map
      });
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime);
    }
    return '';
  }
}

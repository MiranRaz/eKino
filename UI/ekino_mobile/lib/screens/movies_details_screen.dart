import 'dart:convert';
import 'dart:io';

import 'package:ekino_mobile/models/directors.dart';
import 'package:ekino_mobile/models/movies.dart';
import 'package:ekino_mobile/models/search_result.dart';
import 'package:ekino_mobile/providers/directors_provider.dart';
import 'package:ekino_mobile/providers/movies_provider.dart';
import 'package:ekino_mobile/widgets/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class MoviesDetailsScreen extends StatefulWidget {
  Movies? movies;
  MoviesDetailsScreen({super.key, this.movies});

  @override
  State<MoviesDetailsScreen> createState() => MoviesDetailsScreenState();
}

class MoviesDetailsScreenState extends State<MoviesDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  late MoviesProvider _moviesProvider;
  late DirectorsProvider _directorsProvider;

  SearchResult<Director>? directorResult;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      "title": widget.movies?.title,
      "description": widget.movies?.description,
      "year": widget.movies?.year?.toIso8601String(),
      "runningTime": widget.movies?.runningTime,
      "photo": widget.movies?.photo,
      "directorId": widget.movies?.directorId?.toString()
    };

    _directorsProvider = context.read<DirectorsProvider>();
    _moviesProvider = context.read<MoviesProvider>();

    initForm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _directorsProvider = context.read<DirectorsProvider>();
  }

  Future initForm() async {
    directorResult = await _directorsProvider.get();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.movies?.title,
      child: Column(
        children: [
          isLoading ? Container() : _buildForm(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  // Add curly braces here
                  _formKey.currentState?.saveAndValidate();

                  var request = new Map.from(_formKey.currentState!.value);

                  request["photo"] = _base64Image;
                  print("rq slika -> ${request["photo"]}");

                  try {
                    if (widget.movies == null) {
                      await _moviesProvider.insert(request);
                    } else {
                      await _moviesProvider.update(
                          widget.movies!.movieId!, request);
                    }
                  } on Exception catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text("Error "),
                        content: Text(e.toString()),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          ),
                        ],
                      ),
                    );
                  }
                }, // Closing curly brace for onPressed
                child: const Text("Save"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Title"),
                  name: 'title',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Description"),
                  name: 'description',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Year"),
                  name: 'year',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Running Time"),
                  name: 'runningTime',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FormBuilderTextField(
                  decoration: InputDecoration(labelText: "Photo"),
                  name: 'photo',
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: FormBuilderDropdown<String>(
                  name: 'directorId',
                  decoration: InputDecoration(
                    labelText: "Director",
                    suffix: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formKey.currentState?.fields["directorId"]?.reset();
                      },
                    ),
                  ),
                  items: directorResult?.result.map((x) {
                        return DropdownMenuItem(
                          alignment: AlignmentDirectional.center,
                          value: x.directorId.toString(),
                          child: Text(x.fullName ?? ""),
                        );
                      }).toList() ??
                      [],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: FormBuilderField(
                name: "photo",
                builder: ((field) {
                  return InputDecorator(
                    decoration: InputDecoration(
                        label: const Text("Choose a picture"),
                        errorText: field.errorText),
                    child: ListTile(
                      leading: const Icon(Icons.photo),
                      title: const Text("Select image"),
                      trailing: const Icon(Icons.file_upload),
                      onTap: getImage,
                    ),
                  );
                }),
              ))
            ],
          )
        ],
      ),
    );
  }

  File? _image;
  String? _base64Image;

  Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(_image!.readAsBytesSync());
    }
  }
}

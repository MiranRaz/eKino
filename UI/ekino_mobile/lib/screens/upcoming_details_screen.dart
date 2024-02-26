import 'package:ekino_mobile/models/auditorium.dart';
import 'package:ekino_mobile/models/movies.dart';
import 'package:ekino_mobile/models/projection.dart';
import 'package:ekino_mobile/models/user.dart';
import 'package:ekino_mobile/providers/auditorium_provider.dart';
import 'package:ekino_mobile/providers/movies_provider.dart';
import 'package:ekino_mobile/providers/users_provider.dart';
import 'package:ekino_mobile/screens/reservations_new.dart';
import 'package:ekino_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late MoviesProvider _moviesProvider;
  late AuditoriumProvider _auditoriumProvider;
  late UsersProvider _usersProvider;
  List<Movies>? _moviesList;
  List<Auditorium>? _auditoriumList;
  Users? _currentUser;

  String? usernameLS;

  bool isLoading = true;

  Future<String?> _retrieveAndPrintUsernameState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usernameState = prefs.getString('usernameState');
    return usernameState;
  }

  @override
  void initState() {
    super.initState();
    _retrieveAndPrintUsernameState().then((username) {
      setState(() {
        usernameLS = username;
      });
    });
    _initialValue = {
      "dateOfProjection": widget.projection?.dateOfProjection ?? DateTime.now(),
      "movieId": widget.projection?.movie?.movieId.toString(),
      "auditoriumId": widget.projection?.auditoriumId.toString(),
      "ticketPrice": widget.projection?.ticketPrice.toString(),
    };
    _moviesProvider = context.read<MoviesProvider>();
    _auditoriumProvider = context.read<AuditoriumProvider>();
    _usersProvider = context.read<UsersProvider>();

    initForm();
  }

  Future<void> initForm() async {
    final moviesResult = await _moviesProvider.get();
    _moviesList = moviesResult.result;
    final auditoriumResult = await _auditoriumProvider.get();
    _auditoriumList = auditoriumResult.result;
    final currentUser = await _usersProvider.getUsername(usernameLS ?? "");
    _currentUser = currentUser;

    print("user id -> ${currentUser?.userId}");
    print("projection2 ${widget.projection?.projectionId}");

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
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(child: _buildForm()),
      ),
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            child: imageFromBase64String(_moviesList
                    ?.firstWhere((movie) =>
                        movie?.movieId.toString() ==
                        _initialValue['movieId'].toString())
                    ?.photo ??
                ""),
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
            enabled: false,
          ),
          FormBuilderDateTimePicker(
            name: 'dateOfProjection',
            decoration: InputDecoration(labelText: "Date of Projection"),
            inputType: InputType.both,
            format: DateFormat('yyyy-MM-dd HH:mm'),
            enabled: false,
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
            enabled: false,
          ),
          FormBuilderTextField(
            name: 'ticketPrice',
            decoration: InputDecoration(labelText: "Ticket Price"),
            enabled: false,
          ),
          TextFormField(
            initialValue: _moviesList
                    ?.firstWhere((movie) =>
                        movie?.movieId.toString() ==
                        _initialValue['movieId'].toString())
                    ?.description ??
                '', // Retrieve the description corresponding to the selected movie ID
            readOnly: true, // Make the field read-only
            maxLines: null, // Allow the text to span multiple lines
            decoration: InputDecoration(
              labelText: "Movie Description",
            ),
            enabled: false,
          ),
          ElevatedButton(
            onPressed: () async {
              final projection = widget.projection; // Get the projection data
              if (projection != null) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NewReservationScreen(
                    currentUser: _currentUser!,
                    projection: widget.projection!,
                  ),
                ));
              } else {
                _showMessageDialog('Error', 'Projection data is not available');
              }
            },
            child: Text('Reserve seats'),
          ),
        ],
      ),
    );
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

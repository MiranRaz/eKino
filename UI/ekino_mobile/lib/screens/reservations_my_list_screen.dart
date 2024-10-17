import 'package:ekino_mobile/models/user.dart';
import 'package:ekino_mobile/screens/ratings_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ekino_mobile/models/reservation.dart';
import 'package:ekino_mobile/providers/movies_provider.dart';
import 'package:ekino_mobile/providers/projections_provider.dart';
import 'package:ekino_mobile/providers/reservation_provider.dart';
import 'package:ekino_mobile/providers/users_provider.dart';
import 'package:ekino_mobile/screens/reservations_details_screen.dart';
import 'package:ekino_mobile/widgets/master_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationsListScreen extends StatefulWidget {
  const ReservationsListScreen({Key? key}) : super(key: key);

  @override
  State<ReservationsListScreen> createState() => _ReservationsListScreenState();
}

class _ReservationsListScreenState extends State<ReservationsListScreen> {
  late ReservationProvider _reservationsProvider;
  List<Reservation>? _reservations;
  late UsersProvider _usersProvider;
  Users? _currentUser;

  String? usernameLS;

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
      _usersProvider = context.read<UsersProvider>();
      _fetchData();
    });
  }

  void _fetchData() async {
    final currentUser = await _usersProvider.getUsername(usernameLS ?? "");
    _currentUser = currentUser;

    try {
      _reservationsProvider =
          Provider.of<ReservationProvider>(context, listen: false);

      var data;
      if (currentUser?.userId != null) {
        data = await _reservationsProvider.getByUserId(_currentUser?.userId);
      } else {
        data = null;
      }

      setState(() {
        _reservations = data?.result; // Access result only if data is not null
      });
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Reservation List",
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 8.0),
            Expanded(
              child: _buildDataListView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataListView() {
    if (_reservations == null || _reservations!.isEmpty) {
      return Center(
        child: Text(
          'You have no reservations.',
          style: TextStyle(fontSize: 16.0),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _reservations!.length,
        itemBuilder: (context, index) {
          final reservation = _reservations![index];
          // Check if the projection date has passed
          _checkProjectionDate(reservation.projectionId!);
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              onTap: () async {
                // Check if the projection date has passed when the reservation is tapped
                final projectionDate = await _fetchProjectionDate(
                    context, reservation.projectionId!);
                if (projectionDate != 'Unknown') {
                  DateTime dateTime =
                      DateFormat('dd.MM.yyyy HH:mm').parse(projectionDate);
                  if (dateTime.isBefore(DateTime.now())) {
                    _showProjectionPassedModal();
                    return; // Exit if the projection date has passed
                  }
                }
                // Navigate to the reservation details screen if the date has not passed
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ReservationDetailsScreen(
                    reservation: reservation,
                  ),
                ));
              },
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reservation Number: ${reservation.reservationId}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),
                  Text('Seats: ${reservation.row ?? 'Unknown'}'),
                  SizedBox(height: 4.0),
                  Text(
                      'Number of Tickets: ${reservation.numTicket ?? 'Unknown'}'),
                  SizedBox(height: 4.0),
                  FutureBuilder<String>(
                    future: _fetchUserName(context, reservation.userId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        return Text('User: ${snapshot.data ?? 'Unknown'}');
                      }
                    },
                  ),
                  SizedBox(height: 4.0),
                  FutureBuilder<String>(
                    future:
                        _fetchMovieTitle(context, reservation.projectionId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        return Text(
                            'Movie Title: ${snapshot.data ?? 'Unknown'}');
                      }
                    },
                  ),
                  SizedBox(height: 4.0),
                  FutureBuilder<String>(
                    future: _fetchProjectionDate(
                        context, reservation.projectionId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        return Text(
                            'Projection Date and Time: ${snapshot.data ?? 'Unknown'}');
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void _checkProjectionDate(int projectionId) async {
    final projectionDate = await _fetchProjectionDate(context, projectionId);
    if (projectionDate != 'Unknown') {
      DateTime dateTime = DateFormat('dd.MM.yyyy HH:mm').parse(projectionDate);
      if (dateTime.isBefore(DateTime.now())) {
        _showProjectionPassedModal();
      }
    }
  }

  void _showProjectionPassedModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notification'),
          content: Text(
              'The date of some projections has passed. You can see the details of those projection in your ratings screen.'),
          actions: [
            TextButton(
              child: Text('Open Ratings Screen'),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to ratings screen (replace with actual navigation)
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RatingsListScreen(),
                ));
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _fetchUserName(BuildContext context, int userId) async {
    try {
      final user = await Provider.of<UsersProvider>(context, listen: false)
          .getById(userId);
      return user?.username ?? 'Unknown';
    } catch (e) {
      print('Error fetching username: $e');
      return 'Unknown';
    }
  }

  Future<String> _fetchMovieTitle(
      BuildContext context, int projectionId) async {
    try {
      final projectionProvider =
          Provider.of<ProjectionsProvider>(context, listen: false);
      final projection = await projectionProvider.getById(projectionId);

      if (projection != null && projection.movieId != null) {
        final movieId = projection.movieId!;
        final movieProvider =
            Provider.of<MoviesProvider>(context, listen: false);
        final movie = await movieProvider.getById(movieId);
        return movie?.title ?? 'Unknown';
      } else {
        print(
            'Projection or movieId not found for projection ID: $projectionId');
        return 'Unknown';
      }
    } catch (e) {
      print('Error fetching movie title: $e');
      return 'Unknown';
    }
  }

  Future<String> _fetchProjectionDate(
      BuildContext context, int projectionId) async {
    try {
      final projection =
          await Provider.of<ProjectionsProvider>(context, listen: false)
              .getById(projectionId);
      if (projection != null) {
        final formattedDate = DateFormat('dd.MM.yyyy HH:mm')
            .format(projection.dateOfProjection ?? DateTime.now());
        return formattedDate;
      } else {
        return 'Unknown';
      }
    } catch (e) {
      print('Error fetching projection date: $e');
      return 'Unknown';
    }
  }
}

import 'package:ekino_mobile/models/search_result.dart';
import 'package:ekino_mobile/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ekino_mobile/models/reservation.dart';
import 'package:ekino_mobile/providers/projections_provider.dart';
import 'package:ekino_mobile/providers/reservation_provider.dart';
import 'package:ekino_mobile/providers/users_provider.dart';
import 'package:ekino_mobile/screens/reservations_details_screen.dart';
import 'package:ekino_mobile/widgets/master_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationsListScreen extends StatefulWidget {
  const ReservationsListScreen({super.key});

  @override
  State<ReservationsListScreen> createState() => _ReservationsListScreenState();
}

class _ReservationsListScreenState extends State<ReservationsListScreen> {
  late ReservationProvider _reservationsProvider;
  List<Reservation>? _reservations;
  late UsersProvider _usersProvider;
  Users? _currentUser;
  String? usernameLS;

  Future<String?> _retrieveUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('usernameState');
  }

  @override
  void initState() {
    super.initState();
    _retrieveUsername().then((username) {
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
      SearchResult<Reservation>? data;

      if (currentUser.userId != null) {
        data = await _reservationsProvider.getByUserId(_currentUser?.userId);
      } else {
        data = null;
      }

      setState(() {
        _reservations = data?.result ?? [];
      });
    } catch (error) {
      // Handle error appropriately (e.g., show a message to the user)
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
          final movie = reservation.projection?.movie;

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              onTap: () {
                // Navigate to the reservation details screen
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
                  Text('User: ${reservation.user?.username ?? 'Unknown'}'),
                  SizedBox(height: 4.0),
                  Text('Movie Title: ${movie?.title ?? 'Unknown'}'),
                  SizedBox(height: 4.0),
                  FutureBuilder<String>(
                    future: _fetchProjectionDate(
                        context, reservation.projectionId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Show loading indicator
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}'); // Handle error
                      } else {
                        return Text(
                            'Date of Projection: ${snapshot.data ?? 'Unknown'}');
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

  Future<String> _fetchProjectionDate(
      BuildContext context, int projectionId) async {
    try {
      final projection =
          await Provider.of<ProjectionsProvider>(context, listen: false)
              .getById(projectionId);
      if (projection != null) {
        return DateFormat('dd.MM.yyyy HH:mm')
            .format(projection.dateOfProjection);
      } else {
        return 'Unknown';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}

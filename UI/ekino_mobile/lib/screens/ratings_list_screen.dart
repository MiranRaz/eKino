import 'package:ekino_mobile/models/movies.dart';
import 'package:ekino_mobile/models/projection.dart';
import 'package:ekino_mobile/models/rating.dart';
import 'package:ekino_mobile/models/search_result.dart';
import 'package:ekino_mobile/models/user.dart';
import 'package:ekino_mobile/providers/rating_provider.dart';
import 'package:ekino_mobile/screens/ratings_screen.dart';
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

class RatingsListScreen extends StatefulWidget {
  const RatingsListScreen({super.key});

  @override
  State<RatingsListScreen> createState() => _RatingsListScreenState();
}

class _RatingsListScreenState extends State<RatingsListScreen> {
  late RatingProvider _ratingProvider;
  List<Rating>? _rating;
  late ReservationProvider _reservationProvider;
  List<Reservation>? _reservation;
  late UsersProvider _usersProvider;

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

    try {
      _reservationProvider =
          Provider.of<ReservationProvider>(context, listen: false);

      SearchResult<Reservation>? data;
      if (currentUser.userId != null) {
        data = await _reservationProvider.getByUserId(currentUser.userId);
      } else {
        data = null;
      }

      setState(() {
        _reservation = data?.result; // Access result only if data is not null
      });
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Rating",
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
    return ListView.builder(
      itemCount: _reservation?.length ?? 0,
      itemBuilder: (context, index) {
        final reservation = _reservation![index];
        return GestureDetector(
          onTap: () {
            _fetchCurrentUserAndMovie(reservation);
          },
          child: FutureBuilder<String>(
            future: _fetchProjectionDate(context, reservation.projectionId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text('Error fetching projection date');
              } else {
                final projectionDate = DateTime.parse(snapshot.data!);
                if (projectionDate.isBefore(DateTime.now())) {
                  // Only display if projection date is in the future
                  return Card(
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4.0),
                          Text('Projection ID: ${reservation.projectionId}'),
                          FutureBuilder<String>(
                            future: _fetchMovieTitle(
                                context, reservation.projectionId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text('Movie Title: Loading...');
                              } else if (snapshot.hasError) {
                                return Text(
                                    'Movie Title: Error fetching movie title');
                              } else {
                                return Text(
                                    'Movie Title: ${snapshot.data ?? 'Unknown'}');
                              }
                            },
                          ),
                          SizedBox(height: 4.0),
                          Text("Username : $usernameLS"),
                          SizedBox(height: 4.0),
                          Text(
                              'Date: ${DateFormat('dd.MM.yyyy HH:mm').format(projectionDate)}'),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }
            },
          ),
        );
      },
    );
  }

  Future<String> _fetchUserName(BuildContext context, int? userId) async {
    try {
      final user = await Provider.of<UsersProvider>(context, listen: false)
          .getById(userId!);
      return user?.username ?? 'Unknown';
    } catch (e) {
      print('Error fetching username: $e');
      return 'Unknown';
    }
  }

  Future<String> _fetchMovieTitle(
      BuildContext context, int? projectionId) async {
    try {
      final projectionProvider =
          Provider.of<ProjectionsProvider>(context, listen: false);
      final projection = await projectionProvider.getById(projectionId!);

      if (projection != null && projection.movieId != null) {
        final movieProvider =
            Provider.of<MoviesProvider>(context, listen: false);
        final movie = await movieProvider.getById(projection.movieId!);
        return movie?.title ?? 'Unknown';
      } else {
        return 'Unknown';
      }
    } catch (e) {
      print('Error fetching movie title: $e');
      return 'Unknown';
    }
  }

  Future<String> _fetchProjectionDate(
      BuildContext context, int? projectionId) async {
    try {
      final projection =
          await Provider.of<ProjectionsProvider>(context, listen: false)
              .getById(projectionId!);
      if (projection != null) {
        final formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS')
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

  void _fetchCurrentUserAndMovie(Reservation reservation) async {
    final currentUser = await _usersProvider.getUsername(usernameLS ?? "");
    final projection =
        await Provider.of<ProjectionsProvider>(context, listen: false)
            .getById(reservation.projectionId!);
    final userId = currentUser.userId;
    final movieId = projection!.movieId;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => RatingsScreen(userId: userId!, movieId: movieId!),
    ));
  }
}

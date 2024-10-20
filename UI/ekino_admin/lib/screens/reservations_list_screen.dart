import 'package:ekino_admin/models/reservation.dart';
import 'package:ekino_admin/providers/movies_provider.dart';
import 'package:ekino_admin/providers/projections_provider.dart';
import 'package:ekino_admin/providers/reservation_provider.dart';
import 'package:ekino_admin/providers/users_provider.dart';
import 'package:ekino_admin/screens/reservations_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ekino_admin/widgets/master_screen.dart';
import 'package:intl/intl.dart';

class ReservationsListScreen extends StatefulWidget {
  const ReservationsListScreen({super.key});

  @override
  State<ReservationsListScreen> createState() => _ReservationsListScreenState();
}

class _ReservationsListScreenState extends State<ReservationsListScreen> {
  late ReservationProvider _reservationsProvider;
  List<Reservation>? _reservations;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      _reservationsProvider =
          Provider.of<ReservationProvider>(context, listen: false);
      var data = await _reservationsProvider.get();

      setState(() {
        _reservations = data.result;
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
        child: Column(
          children: [
            _buildDataListView(),
          ],
        ),
      ),
    );
  }

  Widget _buildDataListView() {
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(
              label: Text(
                'ID',
              ),
            ),
            DataColumn(
              label: Text(
                'Seats',
              ),
            ),
            DataColumn(
              label: Text(
                'Number of Tickets',
              ),
            ),
            DataColumn(
              label: Text(
                'User',
              ),
            ),
            DataColumn(
              label: Text(
                'Movie Title',
              ),
            ),
            DataColumn(
              label: Text(
                'Projection Date and time',
              ),
            ),
          ],
          rows: _reservations?.map((reservation) {
                return DataRow(
                  onSelectChanged: (_) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ReservationDetailsScreen(
                        reservation: reservation,
                      ),
                    ));
                  },
                  cells: [
                    DataCell(
                      SingleChildScrollView(
                        child:
                            Text(reservation.reservationId?.toString() ?? ""),
                      ),
                    ),
                    DataCell(
                      SingleChildScrollView(
                        child: Text(reservation.row ?? ""),
                      ),
                    ),
                    DataCell(
                      SingleChildScrollView(
                        child: Text(reservation.numTicket ?? ""),
                      ),
                    ),
                    DataCell(
                      FutureBuilder<String>(
                        future: _fetchUserName(context, reservation.userId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            return Text(snapshot.data ?? 'Unknown');
                          }
                        },
                      ),
                    ),
                    DataCell(
                      FutureBuilder<String>(
                        future: _fetchMovieTitle(
                            context, reservation.projectionId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            return Text(snapshot.data ?? 'Unknown');
                          }
                        },
                      ),
                    ),
                    DataCell(
                      FutureBuilder<String>(
                        future: _fetchProjectionDate(
                            context, reservation.projectionId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            return Text(snapshot.data ?? 'Unknown');
                          }
                        },
                      ),
                    ),
                  ],
                );
              }).toList() ??
              [],
        ),
      ),
    );
  }

  Future<String> _fetchUserName(BuildContext context, int userId) async {
    try {
      final user = await Provider.of<UsersProvider>(context, listen: false)
          .getById(userId);
      if (user != null) {
        return user.username ?? 'Unknown';
      } else {
        return 'Unknown';
      }
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

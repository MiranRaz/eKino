import 'package:ekino_mobile/screens/upcoming_details_screen.dart';
import 'package:ekino_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ekino_mobile/models/movies.dart';
import 'package:ekino_mobile/models/projection.dart';
import 'package:ekino_mobile/providers/projections_provider.dart';
import 'package:ekino_mobile/models/search_result.dart';
import 'package:ekino_mobile/widgets/master_screen.dart';

class UpcomingScreen extends StatefulWidget {
  const UpcomingScreen({Key? key}) : super(key: key);

  @override
  _UpcomingScreenState createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {
  late ProjectionsProvider _projectionsProvider;
  SearchResult<Projection>? resultP;

  TextEditingController _ftsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _projectionsProvider = context.read<ProjectionsProvider>();
    _fetchProjections(); // Fetch data when the screen is initialized
  }

  @override
  void dispose() {
    _ftsController.dispose(); // Dispose the TextEditingController
    super.dispose();
  }

  Future<void> _fetchProjections() async {
    var data = await _projectionsProvider.get(filter: {
      'MovieId': _ftsController.text,
    });

    setState(() {
      resultP = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Upcoming projections",
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
        child: Column(
          children: [
            for (int index = 0; index < (resultP?.result.length ?? 0); index++)
              _buildCard(index),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    final Projection projection = resultP!.result[index];
    final Movies? movie = projection.movie;

    // Check if the dateOfProjection is smaller than today
    if (projection.dateOfProjection.isBefore(DateTime.now())) {
      // If it is, return an empty container to hide the card
      return Container();
    }

    // Otherwise, return the card widget
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProjectionDetailsScreen(
              projection: projection,
            ),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 48),
            Container(
              width: double.infinity,
              height: 300,
              child: imageFromBase64String(movie?.photo ?? ""),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${movie?.title}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateFormat('yyyy-MM-dd HH:mm')
                    .format(projection.dateOfProjection),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${movie?.description}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Running Time: ${movie?.runningTime}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

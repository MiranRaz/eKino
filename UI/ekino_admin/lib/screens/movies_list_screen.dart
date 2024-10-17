import 'package:flutter/material.dart';
import 'package:ekino_admin/models/movies.dart';
import 'package:ekino_admin/models/search_result.dart';
import 'package:ekino_admin/providers/movies_provider.dart';
import 'package:ekino_admin/screens/movies_details_screen.dart';
import 'package:ekino_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({super.key});

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  late MoviesProvider _moviesProvider;
  SearchResult<Movies>? result;

  final TextEditingController _ftsController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    _moviesProvider = context.read<MoviesProvider>();
    var data = await _moviesProvider.get(filter: {
      'fts': _ftsController.text,
      'Title': _titleController.text,
    });
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "List",
      child: Container(
        child: Column(
          children: [
            _buildSearch(),
            _buildDataListView(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Row(children: [
      Expanded(
        child: TextField(
          decoration: const InputDecoration(
            labelText: "Search",
          ),
          controller: _ftsController,
        ),
      ),
      Expanded(
        child: TextField(
          decoration: const InputDecoration(
            labelText: "Title",
          ),
          controller: _titleController,
        ),
      ),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: _fetchData,
        child: const Text("Search"),
      ),
      ElevatedButton(
        onPressed: () async {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const MoviesDetailsScreen(
              movies: null,
            ),
          ));
        },
        child: const Text("Add new"),
      ),
    ]);
  }

  Widget _buildDataListView() {
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(
              label: Expanded(
                child: Text(
                  'ID',
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Title',
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Description',
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Year',
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Running time',
                ),
              ),
            ),
          ],
          rows: result?.result
                  .map((Movies r) => DataRow(
                        onSelectChanged: (selected) {
                          if (selected == true) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MoviesDetailsScreen(
                                movies: r,
                              ),
                            ));
                          }
                        },
                        cells: [
                          DataCell(
                            SingleChildScrollView(
                              child: Text(r.movieId?.toString() ?? ""),
                            ),
                          ),
                          DataCell(
                            SingleChildScrollView(
                              child: Text(r.title ?? ""),
                            ),
                          ),
                          DataCell(
                            SingleChildScrollView(
                              child: Text(r.description ?? ""),
                            ),
                          ),
                          DataCell(
                            SingleChildScrollView(
                              child: Text(r.year?.year.toString() ?? ""),
                            ),
                          ),
                          DataCell(
                            SingleChildScrollView(
                              child: Text(r.runningTime ?? ""),
                            ),
                          ),
                        ],
                      ))
                  .toList() ??
              [],
        ),
      ),
    );
  }
}

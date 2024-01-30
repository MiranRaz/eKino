import 'dart:ffi';

import 'package:ekino_admin/models/movies.dart';
import 'package:ekino_admin/models/search_result.dart';
import 'package:ekino_admin/providers/movies_provider.dart';
import 'package:ekino_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({super.key});

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  late MoviesProvider _moviesProvider;
  SearchResult<Movies>? result;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _moviesProvider = context.read<MoviesProvider>();
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
      )),
    );
  }

  Widget _buildSearch() {
    return Row(children: [
      const Expanded(
        child: TextField(
          decoration: InputDecoration(
            labelText: "Search",
          ),
        ),
      ),
      const Expanded(
        child: TextField(
          decoration: InputDecoration(
            labelText: "Title",
          ),
        ),
      ),
      const SizedBox(height: 16),
      ElevatedButton(
          onPressed: () async {
            // Navigator.of(context).pop();
            var data = await _moviesProvider.get();
            setState(() {
              result = data;
            });
          },
          child: const Text("Get")),
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
            )
          ],
          rows: result?.result
                  .map((Movies r) => DataRow(cells: [
                        DataCell(Text(r.movieId?.toString() ?? "")),
                        DataCell(Text(r.title ?? "")),
                        DataCell(Text(r.description ?? "")),
                      ]))
                  .toList() ??
              []),
    ));
  }
}

import 'dart:async';
import 'package:ekino_admin/screens/users_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:ekino_admin/models/user.dart';
import 'package:ekino_admin/models/search_result.dart';
import 'package:ekino_admin/providers/users_provider.dart';
import 'package:ekino_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  late UsersProvider _usersProvider;
  SearchResult<Users>? result;
  late Timer _debounce;

  final TextEditingController _ftsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _debounce = Timer(Duration(milliseconds: 500), () {});
    _fetchData();
  }

  void _fetchData() async {
    _usersProvider = context.read<UsersProvider>();
    var data = await _usersProvider.get(filter: {
      'Username': _ftsController.text,
    });

    setState(() {
      result = data;
    });
  }

  void _onSearchTextChanged(String text) {
    if (_debounce.isActive) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () {
      setState(() {
        _fetchData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "User List",
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
          onChanged: _onSearchTextChanged,
        ),
      ),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: _fetchData,
        child: const Text("Search"),
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
                  'First Name',
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Last Name',
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Username',
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Status',
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Email',
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Phone',
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Role',
                ),
              ),
            ),
          ],
          rows: result?.result
                  .map((user) => DataRow(
                        onSelectChanged: (_) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UserDetailsScreen(
                              user: user,
                            ),
                          ));
                        },
                        cells: [
                          DataCell(
                            SingleChildScrollView(
                              child: Text(user.userId?.toString() ?? ""),
                            ),
                          ),
                          DataCell(
                            SingleChildScrollView(
                              child: Text(user.firstName ?? ""),
                            ),
                          ),
                          DataCell(
                            SingleChildScrollView(
                              child: Text(user.lastName ?? ""),
                            ),
                          ),
                          DataCell(
                            SingleChildScrollView(
                              child: Text(user.username ?? ""),
                            ),
                          ),
                          DataCell(
                            SingleChildScrollView(
                              child: Text(user.status?.toString() ?? ""),
                            ),
                          ),
                          DataCell(
                            SingleChildScrollView(
                              child: Text(user.email ?? ""),
                            ),
                          ),
                          DataCell(
                            SingleChildScrollView(
                              child: Text(user.phone ?? ""),
                            ),
                          ),
                          DataCell(
                            SingleChildScrollView(
                              child: Text(user.roleNames ?? ""),
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

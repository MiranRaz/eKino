import 'package:ekino_admin/main.dart';
import 'package:ekino_admin/screens/users_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:ekino_admin/screens/movies_details_screen.dart';
import 'package:ekino_admin/screens/movies_list_screen.dart';
import 'package:ekino_admin/screens/upcoming_screen.dart';
import 'package:ekino_admin/screens/users_list_screen.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  Widget? title_widget;

  MasterScreenWidget({
    this.child,
    this.title,
    this.title_widget,
    Key? key,
  }) : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: widget.title_widget ?? Text(widget.title ?? "")),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 64,
            ),
            ListTile(
              title: const Text("Upcoming projections"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UpcomingScreen(),
                ));
              },
            ),
            Divider(),
            ListTile(
              title: const Text("Users list"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UsersListScreen(),
                ));
              },
            ),
            ListTile(
              title: const Text("Add new user"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UserDetailsScreen(),
                ));
              },
            ),
            Divider(),
            ListTile(
              title: const Text("Movies list"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MoviesListScreen(),
                ));
              },
            ),
            ListTile(
              title: const Text("Add new movie"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MoviesDetailsScreen(),
                ));
              },
            ),
            Divider(),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  title: const Text("Logout"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MyMaterialApp(),
                    ));
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 124,
            ),
          ],
        ),
      ),
      body: widget.child,
    );
  }
}

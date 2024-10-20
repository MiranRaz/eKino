import 'package:ekino_mobile/main.dart';
import 'package:ekino_mobile/screens/ratings_list_screen.dart';
import 'package:ekino_mobile/screens/reservations_my_list_screen.dart';
import 'package:ekino_mobile/screens/upcoming_screen.dart';
import 'package:ekino_mobile/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  Widget? title_widget;

  MasterScreenWidget({
    this.child,
    this.title,
    this.title_widget,
    super.key,
  });

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
            Divider(),
            ListTile(
              title: const Text("My Profile"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UserProfileScreen(),
                ));
              },
            ),
            Divider(),
            const SizedBox(
              height: 48,
            ),
            Divider(),
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
              title: const Text("My reservations"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ReservationsListScreen(),
                ));
              },
            ),
            Divider(),
            ListTile(
              title: const Text("My ratings"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RatingsListScreen(),
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

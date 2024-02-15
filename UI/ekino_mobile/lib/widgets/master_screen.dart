import 'package:ekino_mobile/main.dart';
import 'package:ekino_mobile/screens/movies_details_screen.dart';
import 'package:ekino_mobile/screens/movies_list_screen.dart';
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
            child: ListView(
          children: [
            ListTile(
              title: const Text("Logout"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MyMaterialApp()));
              },
            ),
            ListTile(
              title: const Text("Movies"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MoviesListScreen()));
              },
            ),
            ListTile(
              title: const Text("Movies details"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MoviesDetailsScreen()));
              },
            ),
            // ListTile(
            //   title: const Text("Directors"),
            //   onTap: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => const DirectorsListScreen()));
            //   },
            // ),
          ],
        )),
        body: widget.child);
  }
}

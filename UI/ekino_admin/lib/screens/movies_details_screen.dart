import 'package:ekino_admin/widgets/master_screen.dart';
import 'package:flutter/material.dart';

class MoviesDetailsScreen extends StatefulWidget {
  const MoviesDetailsScreen({super.key});

  @override
  State<MoviesDetailsScreen> createState() => MoviesDetailsScreenState();
}

class MoviesDetailsScreenState extends State<MoviesDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: "Details", child: const Text("Movies details"));
  }
}

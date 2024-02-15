import 'package:ekino_admin/providers/directors_provider.dart';
import 'package:ekino_admin/providers/movies_provider.dart';
import 'package:ekino_admin/providers/projections_provider.dart';
import 'package:ekino_admin/providers/role_provider.dart';
import 'package:ekino_admin/providers/users_provider.dart';
import 'package:ekino_admin/screens/upcoming_screen.dart';
import 'package:ekino_admin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MoviesProvider()),
      ChangeNotifierProvider(create: (_) => DirectorsProvider()),
      ChangeNotifierProvider(create: (_) => ProjectionsProvider()),
      ChangeNotifierProvider(create: (_) => UsersProvider()),
      ChangeNotifierProvider(create: (_) => RoleProvider())
    ],
    child: const MyMaterialApp(),
  ));
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "eKino Material App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
        ),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  late MoviesProvider _moviesProvider;

  @override
  Widget build(BuildContext context) {
    _moviesProvider = context.read<MoviesProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
          child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Image.asset(
                "assets/images/fit.png",
                height: 100,
                width: 100,
              ),
              TextField(
                decoration: const InputDecoration(
                    labelText: "Username", prefixIcon: Icon(Icons.email)),
                controller: _usernameController,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.password),
                ),
                controller: _passwordController,
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;

                    Authorization.username = username;
                    Authorization.password = password;

                    try {
                      await _moviesProvider.get();

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const UpcomingScreen()));
                    } on Exception catch (e) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                  title: const Text("Error "),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Close")),
                                  ]));
                    }
                  },
                  child: const Text("Login"))
            ]),
          ),
        ),
      )),
    );
  }
}

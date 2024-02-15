import 'package:ekino_mobile/providers/directors_provider.dart';
import 'package:ekino_mobile/providers/movies_provider.dart';
import 'package:ekino_mobile/screens/movies_list_screen.dart';
import 'package:ekino_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MoviesProvider()),
      ChangeNotifierProvider(create: (_) => DirectorsProvider()),
    ],
    child: const MyMaterialApp(),
  ));
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "eKino Material Mobile App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(33, 150, 243, 1),
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
                          builder: (context) => const MoviesListScreen()));
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

import 'package:ekino_admin/providers/movies_provider.dart';
import 'package:ekino_admin/screens/movies_list_screen.dart';
import 'package:ekino_admin/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => MoviesProvider())],
    child: const MyMaterialApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: MyMaterialApp(),
    );
  }
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
                decoration: const InputDecoration(
                    labelText: "Password", prefixIcon: Icon(Icons.password)),
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

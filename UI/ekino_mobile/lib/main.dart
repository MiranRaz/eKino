import 'package:ekino_mobile/providers/auditorium_provider.dart';
import 'package:ekino_mobile/providers/directors_provider.dart';
import 'package:ekino_mobile/providers/movies_provider.dart';
import 'package:ekino_mobile/providers/projections_provider.dart';
import 'package:ekino_mobile/providers/rating_provider.dart';
import 'package:ekino_mobile/providers/reservation_provider.dart';
import 'package:ekino_mobile/providers/role_provider.dart';
import 'package:ekino_mobile/providers/transaction_provider.dart';
import 'package:ekino_mobile/providers/users_provider.dart';
import 'package:ekino_mobile/screens/upcoming_screen.dart';
import 'package:ekino_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart' as FlutterMaterial;

import '.env';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  await Stripe.instance.applySettings();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MoviesProvider()),
      ChangeNotifierProvider(create: (_) => DirectorsProvider()),
      ChangeNotifierProvider(create: (_) => ProjectionsProvider()),
      ChangeNotifierProvider(create: (_) => ReservationProvider()),
      ChangeNotifierProvider(create: (_) => UsersProvider()),
      ChangeNotifierProvider(create: (_) => RoleProvider()),
      ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ChangeNotifierProvider(create: (_) => AuditoriumProvider()),
      ChangeNotifierProvider(create: (_) => RatingProvider()),
    ],
    child: const MyMaterialApp(),
  ));
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

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
  LoginPage({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late MoviesProvider _moviesProvider;

  @override
  Widget build(BuildContext context) {
    _moviesProvider = context.read<MoviesProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
          child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
        child: FlutterMaterial.Card(
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
                  child: const Text("Login")),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RegistrationPage()));
                },
                child: const Text("Register"),
              )
            ]),
          ),
        ),
      )),
    );
  }
}

class RegistrationPage extends StatelessWidget {
  RegistrationPage({super.key});

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
          child: FlutterMaterial.Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                TextField(
                  decoration: const InputDecoration(labelText: "First Name"),
                  controller: _firstNameController,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(labelText: "Last Name"),
                  controller: _lastNameController,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(labelText: "Username"),
                  controller: _usernameController,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(labelText: "Email"),
                  controller: _emailController,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(labelText: "Phone"),
                  controller: _phoneController,
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password"),
                  controller: _passwordController,
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: "Confirm Password"),
                  controller: _passwordConfirmationController,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    var user = {
                      "firstName": _firstNameController.text,
                      "lastName": _lastNameController.text,
                      "username": _usernameController.text,
                      "status": true,
                      "email": _emailController.text,
                      "phone": _phoneController.text,
                      "password": _passwordController.text,
                      "passwordConfirmation":
                          _passwordConfirmationController.text,
                      "roleIdList": [2]
                    };

                    try {
                      await context
                          .read<UsersProvider>()
                          .register(user, context);
                      Navigator.of(context).pop();
                    } catch (error) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text("Error"),
                          content: Text(error.toString()),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Close"),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text("Register"),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

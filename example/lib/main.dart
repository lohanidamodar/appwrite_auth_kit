import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Client client;
  @override
  void initState() {
    super.initState();
    client = Client();
    client
        .setEndpoint('https://demo.appwrite.io/v1')
        .setProject('606e4205b3b5c')
        .setSelfSigned();
  }

  @override
  Widget build(BuildContext context) {
    return AppwriteAuthKit(
      client: client,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.authNotifier;

    Widget widget;
    switch (authNotifier.status) {
      case AuthStatus.authenticated:
        widget = const AdminPage();
        break;
      case AuthStatus.unauthenticated:
      case AuthStatus.authenticating:
        widget = const LoginPage();
        break;
      case AuthStatus.uninitialized:
      default:
        widget = const LoadingPage();
        break;
    }
    return widget;
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.authNotifier.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin page'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          if (user != null) ...[
            Text(user.name),
            Text(user.email),
            const SizedBox(height: 20.0),
            ElevatedButton(
                onPressed: () {
                  context.authNotifier.deleteSession();
                },
                child: const Text("Logout"))
          ]
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _email;
  late TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 30.0),
            Text(
              "FlAppwrite Account Kit Example",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 20.0),
            Card(
              margin: const EdgeInsets.all(32.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListView(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                children: [
                  const SizedBox(height: 20.0),
                  Text(
                    "Log In",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.red,
                        ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _email,
                    decoration: const InputDecoration(
                      labelText: "Enter email",
                    ),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Enter password",
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      final authNotifier = context.authNotifier;

                      if (!await authNotifier.createEmailPasswordSession(
                          email: email, password: password)) {
                        scaffoldMessenger.showSnackBar(SnackBar(
                            content: Text(authNotifier.error ??
                                "Unknown error")));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                    ),
                    child: const Text("Login"),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

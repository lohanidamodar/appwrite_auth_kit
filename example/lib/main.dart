import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Client client;
  @override
  void initState() {
    super.initState();
    client = Client();
    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('appwrite-auth-kit-demo');
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
        home: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authNotifier = context.authNotifier;

    Widget widget;
    switch (authNotifier.status) {
      case AuthStatus.authenticated:
        widget = AdminPage();
        break;
      case AuthStatus.unauthenticated:
      case AuthStatus.authenticating:
        widget = LoginPage();
        break;
      case AuthStatus.uninitialized:
      default:
        widget = LoadingPage();
        break;
    }
    return widget;
  }
}

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.authNotifier.user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin page'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          if (user != null) ...[
            Text(user.name),
            Text(user.email),
            const SizedBox(height: 20.0),
            ElevatedButton(
                onPressed: () async {
                  await context.authNotifier.deleteSession();
                },
                child: Text("Logout"))
          ]
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
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
                physics: NeverScrollableScrollPhysics(),
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
                    decoration: InputDecoration(
                      labelText: "Enter email",
                    ),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Enter password",
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    child: Text("Login"),
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;

                      if (!await context.authNotifier.createEmailSession(
                          email: email, password: password)) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(context.authNotifier.error ??
                                "Unknown error")));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                    ),
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

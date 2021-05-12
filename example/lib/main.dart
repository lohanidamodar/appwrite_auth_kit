import 'package:appwrite_flutter_accounts/appwrite_flutter_accounts.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Client client;
  late Account account;
  @override
  void initState() {
    super.initState();
    client = Client();
    client
        .setEndpoint('https://localhost/v1')
        .setProject('60793ca4ce59e')
        .setSelfSigned()
        .addHeader('Origin', 'http://localhost');

    account = Account(client);
  }

  @override
  Widget build(BuildContext context) {
    return AppwriteAccountProvider(
      client: account,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
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
    switch (authNotifier?.status ?? AuthStatus.uninitialized) {
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
    final user = context.authNotifier?.user;
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
                onPressed: () {
                  context.authNotifier?.deleteSession();
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
              "Appwrite Auth Provider Example",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3?.copyWith(
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
                    style: Theme.of(context).textTheme.headline5?.copyWith(
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
                      //login
                      final email = _email.text;
                      final password = _password.text;

                      //do client side validation
                      if (!(await context.authNotifier
                              ?.createSession(email: email, password: password) ??
                          false)) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(context.authNotifier?.error ??
                                "Unknown error")));
                        // _password.clear();
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

import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:flutter/material.dart';

import 'signup.dart';

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
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ));
                      },
                      child: const Text('Sign Up')),
                  SizedBox(height: 20.0),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:flutter/material.dart';

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
                onPressed: () {
                  context.authNotifier.deleteSession();
                },
                child: Text("Logout"))
          ]
        ],
      ),
    );
  }
}

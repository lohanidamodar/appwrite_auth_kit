import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:flutter/material.dart';

import 'admin.dart';
import 'loading.dart';
import 'login.dart';

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
        .setEndpoint('http://172.20.0.7/v1')
        .setProject('63c39409d6a8a5cd05bd')
        .setSelfSigned();
  }

  @override
  Widget build(BuildContext context) {
    return AppwriteAuthKit(
      client: client,
      child: MaterialApp(
        title: 'TeleTest',
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

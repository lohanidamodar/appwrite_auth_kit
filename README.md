# FlAppwrite Account Kit

A Flutter wrapper for Appwrite's Accounts service, makes it easy to use manage authentication and account features.

**Under development. Not ready for production. Help get ready for production.**

## Getting Started
This is really very easy to use
1. Add dependency from git (Will only publish to pub if enough people are interested to use and help make it better.)

```yaml
dependencies:
    flappwrite_account_kit:
        git: https://github.com/lohanidamodar/flappwrite_account_kit
```
1. Wrap your MaterialApp `FlAppwriteAccountKit` passing a properly initialized Appwrite Client. Example below:

```dart
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Client client;
  @override
  void initState() {
    super.initState();
    //initialize your client
    client = Client();
    client
        .setEndpoint('https://localhost/v1')
        .setProject('60793ca4ce59e')
        .setSelfSigned();
  }

  @override
  Widget build(BuildContext context) {
    return FlAppwriteAccountKit(
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
```

2. Access `authNotifier` from `context`. `authNotifier` is an instance of `AuthNotifier` that provides all the functions of Appwrite's Account service and some easy way to handle authentication.
3. Get `context.authNotifier?.status` gets the authentication status which can be one of the `AuthStatus.uninitialized`, `AuthStatus.unauthenticated`, `AuthStatus.authenticating` and `AuthStatus.authenticated`. You can check the status and display the appropriate UI, for example

```dart
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
```
4. You must use the functions from the `context.authNotifier` instead default Account service from Appwrite SDK to create user, create session (login), delete session (logout), so that the `context.authNotifier?.status` is properly updated and your UI updates accordingly.
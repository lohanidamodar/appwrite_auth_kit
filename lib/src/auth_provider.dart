import 'package:appwrite_flutter_accounts/src/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:appwrite/appwrite.dart';

extension AppwriteAuthProviderExt on BuildContext {
  AuthNotifier? get authNotifier => AppwriteAccountProvider.of(this);
}

/// Exposes Nhost authentication information to its subtree.
class AppwriteAccountProvider extends InheritedNotifier<AuthNotifier> {
  AppwriteAccountProvider({
    Key? key,
    required Account account,
    required Widget child,
  }) : super(
          key: key,
          notifier: AuthNotifier(account),
          child: child,
        );

  @override
  bool updateShouldNotify(InheritedNotifier<AuthNotifier> oldWidget) {
    return oldWidget.notifier != notifier;
  }

  static AuthNotifier? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppwriteAccountProvider>()
        ?.notifier;
  }
}

enum AuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated,
}

/// A [Listenable] that notifies when Nhost authentication states changes
class AuthNotifier extends ChangeNotifier {
  final Account _account;
  AuthStatus _status = AuthStatus.uninitialized;
  User? _user;
  String? _error;
  late bool _loading;

  AuthNotifier(Account account) : this._account = account {
    _error = '';
    _loading = true;
    _getUser();
  }

  String? get error => _error;
  bool get isLoading => _loading;
  User? get user => _user;
  AuthStatus get status => _status;

  Future _getUser() async {
    try {
      final res = await _account.get();
      _user = User.fromMap(res.data);
      _status = AuthStatus.authenticated;
    } on AppwriteException catch (e) {
      _status = AuthStatus.unauthenticated;
      _error = e.message;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future deleteSession() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      _user = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    } on AppwriteException catch (e) {
      _error = e.message;
      print(_error);
      return false;
    }
  }

  Future createSession({required String email, required String password}) async {
    _status = AuthStatus.authenticating;
    notifyListeners();
    try {
      await _account.createSession(email: email, password: password);
      _getUser();
      return true;
    } on AppwriteException catch (e) {
      _error = e.message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  /// Create account
  /// 
  Future<bool> create({required String name, required String email, required String password}) async {
    _status = AuthStatus.authenticating;
    notifyListeners();
    try {
      await _account.create(name: name, email: email, password: password);
      _error = '';
      await createSession(email: email, password: password);
      return true;
    } on AppwriteException catch (e) {
      _error = e.message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }
}

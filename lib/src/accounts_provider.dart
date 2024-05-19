import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/widgets.dart';

extension AppwriteAuthKitExt on BuildContext {
  AuthNotifier get authNotifier => AppwriteAuthKit.of(this);
}

class AppwriteAuthKit extends InheritedNotifier<AuthNotifier> {
  AppwriteAuthKit({
    super.key,
    required Client client,
    required super.child,
  }) : super(
          notifier: AuthNotifier(client),
        );

  @override
  bool updateShouldNotify(InheritedNotifier<AuthNotifier> oldWidget) {
    return oldWidget.notifier != notifier;
  }

  static AuthNotifier of(BuildContext context) {
    final AuthNotifier? result =
        context.dependOnInheritedWidgetOfExactType<AppwriteAuthKit>()?.notifier;
    assert(result != null, 'No AuthNotifier found in context');
    return result!;
  }
}

enum AuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated,
}

class AuthNotifier extends ChangeNotifier {
  late final Account _account;
  final Client _client;
  AuthStatus _status = AuthStatus.uninitialized;

  User? _user;
  String? _error;
  late bool _loading;

  AuthNotifier(Client client) : _client = client {
    _error = '';
    _loading = true;
    _account = Account(client);
    _getUser();
  }

  Account get account => _account;

  Client get client => _client;

  String? get error => _error;

  bool get isLoading => _loading;

  User? get user => _user;

  AuthStatus get status => _status;

  Future _getUser({bool notify = true}) async {
    try {
      _user = await _account.get();
      _status = AuthStatus.authenticated;
    } on AppwriteException catch (e) {
      _status = AuthStatus.unauthenticated;
      _error = e.message;
    } finally {
      _loading = false;
      if (notify) {
        notifyListeners();
      }
    }
  }

  Future<bool> deleteSession({String sessionId = 'current'}) async {
    try {
      await _account.deleteSession(sessionId: sessionId);
      _user = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } on AppwriteException catch (e) {
      _error = e.message;
      return false;
    }
  }

  Future<bool> deleteSessions() async {
    try {
      await _account.deleteSessions();
      _user = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } on AppwriteException catch (e) {
      _error = e.message;
      return false;
    }
  }

  Future<bool> createEmailPasswordSession({
    required String email,
    required String password,
    bool notify = true,
  }) async {
    _status = AuthStatus.authenticating;
    if (notify) {
      notifyListeners();
    }
    try {
      await _account.createEmailPasswordSession(
          email: email, password: password);
      _getUser(notify: notify);
      return true;
    } on AppwriteException catch (e) {
      _error = e.message;
      _status = AuthStatus.unauthenticated;
      if (notify) {
        notifyListeners();
      }
      return false;
    }
  }

  Future<bool> createPhoneToken({
    required String userId,
    required String number,
  }) async {
    _status = AuthStatus.authenticating;
    notifyListeners();
    try {
      await _account.createPhoneToken(userId: userId, phone: number);
      return true;
    } on AppwriteException catch (e) {
      _error = e.message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePhoneSession({
    required String userId,
    required String secret,
  }) async {
    _status = AuthStatus.authenticating;
    notifyListeners();
    try {
      await _account.updatePhoneSession(userId: userId, secret: secret);
      await _getUser();
      return true;
    } on AppwriteException catch (e) {
      _error = e.message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> createAnonymousSession() async {
    _status = AuthStatus.authenticating;
    notifyListeners();
    try {
      await _account.createAnonymousSession();
      _getUser();
      return true;
    } on AppwriteException catch (e) {
      _error = e.message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> createMagicURLToken({
    required String email,
    String userId = 'unique()',
    String? url,
  }) async {
    _status = AuthStatus.authenticating;
    notifyListeners();
    try {
      await _account.createMagicURLToken(
          userId: userId, email: email, url: url);
      return true;
    } on AppwriteException catch (e) {
      _error = e.message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateMagicURLSession({
    required String userId,
    required String secret,
  }) async {
    _status = AuthStatus.authenticating;
    notifyListeners();
    try {
      await _account.updateMagicURLSession(userId: userId, secret: secret);
      _getUser();
      return true;
    } on AppwriteException catch (e) {
      _error = e.message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<Jwt?> createJWT() async {
    try {
      return await _account.createJWT();
    } on AppwriteException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  /// Create account
  ///
  Future<User?> create({
    required String email,
    required String password,
    String userId = 'unique()',
    bool notify = true,
    bool newSession = true,
    String? name,
  }) async {
    _status = AuthStatus.authenticating;
    if (notify) {
      notifyListeners();
    }
    try {
      final user = await _account.create(
          userId: userId, name: name, email: email, password: password);
      _error = '';
      if (newSession) {
        await createEmailPasswordSession(email: email, password: password);
      }
      return user;
    } on AppwriteException catch (e) {
      _error = e.message;
      _status = AuthStatus.unauthenticated;
      if (notify) {
        notifyListeners();
      }
      return null;
    }
  }

  Future<bool> updateStatus() async {
    try {
      await _account.updateStatus();
      _getUser();
      return true;
    } on AppwriteException catch (e) {
      _error = e.message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<User?> updatePrefs({required Map<String, dynamic> prefs}) async {
    try {
      _user = await _account.updatePrefs(prefs: prefs);
      notifyListeners();
      return _user;
    } on AppwriteException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  Future<LogList?> listLogs({int? limit, int? offset}) async {
    try {
      return await _account.listLogs(queries: [
        if (limit != null) Query.limit(limit),
        if (offset != null) Query.offset(offset),
      ]);
    } on AppwriteException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  Future<bool> createOAuth2Session({
    required OAuthProvider provider,
    String? success,
    String? failure,
    List<String>? scopes,
  }) async {
    try {
      await _account.createOAuth2Session(
        provider: provider,
        success: success,
        failure: failure,
        scopes: scopes,
      );
      _getUser();
      return true;
    } on AppwriteException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<Session?> getSession({required String sessionId}) async {
    try {
      return await _account.getSession(sessionId: sessionId);
    } on AppwriteException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  Future<SessionList?> listSessions() async {
    try {
      return await _account.listSessions();
    } on AppwriteException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  Future<User?> updateName({required String name}) async {
    try {
      _user = await _account.updateName(name: name);
      notifyListeners();
      return _user;
    } on AppwriteException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  Future<User?> updatePhone({
    required String number,
    required String password,
  }) async {
    try {
      _user = await _account.updatePhone(phone: number, password: password);
      notifyListeners();
      return _user;
    } on AppwriteException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  Future<User?> updateEmail({
    required String email,
    required String password,
  }) async {
    try {
      _user = await _account.updateEmail(email: email, password: password);
      notifyListeners();
      return _user;
    } on AppwriteException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  Future<User?> updatePassword({
    required String password,
    String? oldPassword,
  }) async {
    try {
      _user = await _account.updatePassword(
          password: password, oldPassword: oldPassword);
      notifyListeners();
      return _user;
    } on AppwriteException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  //createRecovery
  Future<Token?> createRecovery({
    required String email,
    required String url,
  }) async {
    try {
      return await _account.createRecovery(email: email, url: url);
    } on AppwriteException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  //updateRecovery
  Future<Token?> updateRecovery({
    required String userId,
    required String password,
    required String secret,
  }) async {
    try {
      return await _account.updateRecovery(
          userId: userId, password: password, secret: secret);
    } on AppwriteException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  //createVerification
  Future<Token?> createVerification({required String url}) async {
    try {
      return await _account.createVerification(url: url);
    } on AppwriteException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  //updateVerification
  Future<Token?> updateVerification({
    required String userId,
    required String secret,
  }) async {
    try {
      return await _account.updateVerification(userId: userId, secret: secret);
    } on AppwriteException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  /// createPhoneVerification
  Future<Token?> createPhoneVerification() async {
    try {
      return await _account.createPhoneVerification();
    } on AppwriteException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  /// updatePhoneVerification
  Future<Token?> updatePhoneVerification({
    required String userId,
    required String secret,
  }) async {
    try {
      return await _account.updatePhoneVerification(
          userId: userId, secret: secret);
    } on AppwriteException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    }
  }
}

import 'package:seva_map/data/database_helper.dart';

enum AuthState{ LOGGED_IN, LOGGED_OUT }

abstract class AuthStateListener {
  void onAuthStateChanged(AuthState state);
}

// A naive implementation of Observer/Subscriber Pattern. Will do for now.
class AuthStateProvider {
  static final AuthStateProvider _instance = AuthStateProvider.internal();

  late List<AuthStateListener> _subscribers;

  factory AuthStateProvider() => _instance;
  AuthStateProvider.internal() {
    _subscribers = <AuthStateListener>[];
    initState();
  }

  void initState() async {
    var db = DatabaseHelper();
    var isLoggedIn = await db.isLoggedIn();
    if(isLoggedIn) {
      notify(AuthState.LOGGED_IN);
    } else {
      notify(AuthState.LOGGED_OUT);
    }
  }

  void subscribe(AuthStateListener listener) {
    _subscribers.add(listener);
  }

  void dispose(AuthStateListener listener) {
    for(var l in _subscribers) {
      if(l == listener) {
        _subscribers.remove(l);
      }
    }
  }

  void notify(AuthState state) {
    for (var s in _subscribers) {
      s.onAuthStateChanged(state);
    }
  }
}
import 'package:seva_map/data/rest_ds.dart';
import 'package:seva_map/models/user.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(User user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  final LoginScreenContract _view;
  RestDatasource api = RestDatasource();
  LoginScreenPresenter(this._view);

  doLogin(String username, String password) {
    api.login(username, password).then((User user) {
      _view.onLoginSuccess(user);
    }).catchError((error){
      _view.onLoginError(error.toString());
    });
  }
}
import 'package:seva_map/data/rest_ds.dart';
import 'package:seva_map/models/user.dart';

abstract class SignUpScreenContract {
  void onSignUpSuccess(dynamic response);
  void onSignUpError(String errorTxt);
}

class SignUpScreenPresenter {
  final SignUpScreenContract _view;
  RestDatasource api = RestDatasource();
  SignUpScreenPresenter(this._view);

  doSignUp(String email, String password,String countryCode,String phone,String orgName,String contactPerson,String role, String status) {
    api.signUp(email, password, countryCode, phone, orgName,contactPerson,role, status).then((dynamic response) {
      _view.onSignUpSuccess(response);
    }).catchError((error){
      _view.onSignUpError(error.toString());
    });
  }
}
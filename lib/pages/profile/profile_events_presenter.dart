import 'package:seva_map/data/rest_ds.dart';

abstract class ProfileEventsContract {
  void onProfileEventsSuccess(dynamic response);
  void onProfileEventsError(String errorTxt);
}

class ProfileEventsPresenter {
  final ProfileEventsContract _view;
  RestDatasource api = RestDatasource();
  ProfileEventsPresenter(this._view);

  doMyEvents(String createdBy) {
    api.myEvents(createdBy).then((dynamic response) {
      _view.onProfileEventsSuccess(response);
    }).catchError((error){
      _view.onProfileEventsError(error.toString());
    });
  }
}
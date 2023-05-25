import 'package:seva_map/data/rest_ds.dart';

abstract class EventListContract {
  void onEventListSuccess(List successTxt);
  void onEventListError(String errorTxt);
}

class EventListPresenter {
  final EventListContract _view;
  RestDatasource api = RestDatasource();
  EventListPresenter(this._view);

  doGetNearEventList(String latitude,String longitude) {
    api.getNearEventList(latitude, longitude ).then((List eventList) {
      print('..doGeteventList....>$eventList');
      _view.onEventListSuccess(eventList);
    }).catchError((error){
      _view.onEventListError(error.toString());
    });
  }
}

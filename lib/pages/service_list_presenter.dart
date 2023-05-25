import 'package:seva_map/data/rest_ds.dart';

abstract class ServiceListContract {
  void onServiceListSuccess(List successTxt);
  void onServiceListError(String errorTxt);
}

class ServiceListPresenter {
  final ServiceListContract _view;
  RestDatasource api = RestDatasource();
  ServiceListPresenter(this._view);

  doGetNearServiceList(String latitude,String longitude) {
    api.getNearServiceList(latitude, longitude ).then((List serviceList) {
      print('..doGetServiceList....>$serviceList');
      _view.onServiceListSuccess(serviceList);
    }).catchError((error){
      _view.onServiceListError(error.toString());
    });
  }
}

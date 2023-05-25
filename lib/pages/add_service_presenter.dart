import 'package:seva_map/data/rest_ds.dart';

abstract class AddServiceContract {
  void onAddServiceSuccess(String successTxt);
  void onAddServiceError(String errorTxt);
}

abstract class AddEventContract {
  void onAddEventSuccess(String successTxt);
  void onAddEventError(String errorTxt);
}

class AddServicePresenter {
  final AddServiceContract _view;
  RestDatasource api = RestDatasource();
  AddServicePresenter(this._view);

  doAddService(String categoryId,String title, String shortDescription,String detailedDescription, String countryCode,String phone,String email,String latitude,String longitude,String createdBy) {
    api.addService(categoryId,title,shortDescription,detailedDescription,countryCode,phone,email,latitude,longitude,createdBy ).then((String text) {
      print('......>$text');
      _view.onAddServiceSuccess(text);
    }).catchError((error){
      _view.onAddServiceError(error.toString());
    });
  }
}

class AddEventPresenter {
  final AddEventContract _view;
  RestDatasource api = RestDatasource();
  AddEventPresenter(this._view);

  doAddEvent(String title, String subTitle,String startDate, String endDate,String startTime,String endTime, String countryCode,String phone,String email,String orgName,String latitude,String longitude,String createdBy,String status) {
    api.addEvent(title,subTitle,startDate,endDate,startTime,endTime,countryCode,phone,email,orgName,latitude,longitude,createdBy,status).then((String text) {
      print('...event...>$text');
      _view.onAddEventSuccess(text);
    }).catchError((error){
      _view.onAddEventError(error.toString());
    });
  }
}
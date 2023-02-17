import 'dart:developer';

import 'package:qms_client/core/utils/conversion.dart';
import 'package:qms_client/models/data_model_model.dart';

import '../core/api/api_services.dart';
import '../core/constants/api_endpoints.dart';
import '../models/mobile_response.dart';

class ConfigureServices {
  ApiService api = ApiService();

  Future<MobileResponse<int>> getClientId(String clientCode) async {
    ApiService api = ApiService();
    var url = ApiUrl.verifyClientCode.format(params: [clientCode]);
    var result = await api.get(url);
    var response = MobileResponse<int>.fromJson(result, (json) {
      return json['data'];
    });
    return response;
  }

  Future<MobileResponse<List<DataModel>>> getServiceCentreList(
      int clientId) async {
    var url = ApiUrl.getServiceCentreListUrl.format(params: [clientId]);
    var result = await api.get(url);
    var response = MobileResponse<List<DataModel>>.fromJson(result, (jsonn) {
      List data = jsonn;
      List<DataModel> dataList =
          data.map((i) => DataModel.fromJson(i)).toList();
      return dataList;
    });
    return response;
  }

  Future<MobileResponse<List<DataModel>>> getKioskList(
      int serviceCentreId) async {
    var url = ApiUrl.getKioskListUrl.format(params: [serviceCentreId]);
    var result = await api.get(url);
    var response = MobileResponse<List<DataModel>>.fromJson(result, (json) {
      List data = json;
      List<DataModel> dataList =
          data.map((i) => DataModel.fromJson(i)).toList();
      log('response$dataList');
      return dataList;
    });
    return response;
  }
}

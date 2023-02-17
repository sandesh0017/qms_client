import 'package:qms_client/core/utils/conversion.dart';
import 'package:qms_client/models/data_model_model.dart';

import '../core/api/api_services.dart';
import '../core/constants/api_endpoints.dart';
import '../models/mobile_response.dart';

class ServiceOfferedServices {
  ApiService api = ApiService();
  Future<MobileResponse<List<DataModel>>> getServiceOffered(int kioskId) async {
    var url = ApiUrl.getServiceOfferedUrl.format(params: [kioskId]);
    var result = await api.get(url);
    var response = MobileResponse<List<DataModel>>.fromJson(result, (json) {
      List data = json;
      List<DataModel> dataList =
          data.map((i) => DataModel.fromJson(i)).toList();
      return dataList;
    });
    return response;
  }

  Future<MobileResponse<String>> getNewTokenNumber(
      int serviceCentreId, int kioskId, int serviceOffereId) async {
    var url = ApiUrl.getNewTokenNumberUrl
        .format(params: [serviceCentreId, kioskId, serviceOffereId]);
    var result = await api.get(
      url,
    );
    var response = MobileResponse<String>.fromJson(result, (json) {
      return json['data'];
    });
    return response;
  }
}

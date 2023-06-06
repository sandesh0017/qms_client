import '../local/storage.dart';

class ApiUrl {
  // static String baseUrl = "https://192.168.20.40:44362";
  // static String baseUrl = "http://192.168.1.33";
  static String baseUrl = "http://10.8.7.93";

  static String verifyClientCode = '$baseUrl/api/Caller/VerifyClientCode/{0}';

  static String getServiceCentreListUrl =
      "$baseUrl/api/kiosk/GetServiceCenterList/{0}";

  static String getKioskListUrl = "$baseUrl/api/kiosk/GetKioskList/{0}";

  static String getServiceOfferedUrl =
      "$baseUrl/api/kiosk/GetServiceOffered/{0}";

  static String getNewTokenNumberUrl =
      "$baseUrl/api/kiosk/GetNewTokenNumber?serviceCenterId={0}&kiosKId={1}&serviceOfferId={2}";

  static setNewBaseUrl(String newBaseUrl) {
    // baseUrl = newBaseUrl;
    // SessionPreferences().setBaseUrl(baseUrl: newBaseUrl);
    HiveHelper().setBaseURL(baseUrl: newBaseUrl);
  }
}

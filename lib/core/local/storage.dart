import 'dart:developer';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qms_client/core/constants/api_endpoints.dart';
import 'package:qms_client/core/local/set_session.dart';

import '../../models/printer_detail.dart';

class HiveHelper {
  Future<void> setSession(
      {String? clientCode,
      String? koiskIdCode,
      int? serviceCentreCode,
      String? serviceCentreName}) async {
    await Hive.openBox('myBox');
    Box box = Hive.box('myBox');
    await box.put(
        'setSess',
        SetSess(
            clientCode: clientCode,
            koiskIdCode: koiskIdCode,
            serviceCentreCode: serviceCentreCode,
            serviceCentreName: serviceCentreName));
  }

  getSessionHive() async {
    Box box = Hive.box('myBox');
    SetSess? sess = await box.get('setSess');
    if (sess != null) {
      log("hurray session $sess");
      return sess;
    } else {
      return null;
    }
  }

  clearSession() {
    Box box = Hive.box('myBox');
    box.delete('setSess');
  }

  Future<void> setPrinterHive(
      {int? id,
      String? deviceName,
      String? address,
      String? productId,
      String? vendorId,
      bool? isBle,
      required PrinterType typePrinter}) async {
    await Hive.initFlutter();
    Hive.openBox('myBox');
    Box box = Hive.box('myBox');
    box.put('id', id);
    box.put('deviceName', deviceName);
    box.put('address', address);
    box.put('productId', productId);
    box.put('vendorId', vendorId);
    box.put('isBle', isBle);
    box.put('typePrinter', typePrinter);

    log('${box.values}set PPP');
  }

  PrinterDetail? getPrinterHive() {
    Hive.openBox('myBox');
    Box box = Hive.box('myBox');

    String? deviceName = box.get('deviceName');
    String? address = box.get('address');
    // String? port = box.get('port');
    String? vendorId = box.get('vendorId');
    String? productId = box.get('productId');
    bool? isBle = box.get('isBle');
    PrinterType? typePrinter = box.get('typePrinter');

    PrinterDetail sessPrinter = PrinterDetail(
        address: address,
        deviceName: deviceName,
        isBle: isBle,
        productId: productId,
        typePrinter: typePrinter ?? PrinterType.usb,
        vendorId: vendorId);
    if (sessPrinter.deviceName != null) {
      log("hurray sessPrinterion $sessPrinter");
      return sessPrinter;
    } else {
      return null;
    }
  }

  clearPrinterSession() async {
    Box box = Hive.box('myBox');
    box.delete('id');
    box.delete('deviceName');
    box.delete('address');
    box.delete('productId');
    box.delete('vendorId');
    box.delete('isBle');
    box.delete('typePrinter');
  }

  setBaseURL({String? baseUrl}) {
    Hive.openBox('myBox');
    Box box = Hive.box('myBox');
    box.put('baseUrl', baseUrl);
  }

  getBaseUrl() {
    Hive.openBox('myBox');
    Box box = Hive.box('myBox');
    String? baseUrl = box.get('baseUrl');
    if (baseUrl != null) {
      return baseUrl;
    }
    return ApiUrl.baseUrl;
  }

  ////////////////////////////GENERIC//////////////////////////////////////
  setCompanyName({String? companyName}) {
    Hive.openBox('myBox');
    Box box = Hive.box('myBox');
    box.put('companyName', companyName);
  }

  getCompanyName() {
    Hive.openBox('myBox');
    Box box = Hive.box('myBox');
    String? companyName = box.get('companyName');
    if (companyName != null) {
      return companyName;
    }
    return null;
  }

  setCompanyLogo({String? companyLogo}) {
    Hive.openBox('myBox');
    Box box = Hive.box('myBox');
    box.put('logo', companyLogo);
  }

  getCompanyLogo() {
    Hive.openBox('myBox');
    Box box = Hive.box('myBox');
    String? logo = box.get('logo');
    if (logo != null) {
      return logo;
    }
    return null;
  }
}

/////////////////////////////////////////////   SHARED PREF CODE /////////////////////////////////////////
// class SessionPreferences {
//   static Future<SharedPreferences> _initSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs;
//   }

  // Future<void> setSession({required UserSession userSession}) async {
  //   SharedPreferences prefs = await _initSharedPreferences();
  //   prefs.setString('session', jsonEncode(userSession));
  // }

  // Future<void> setPrinterDetails({required PrinterDetail printerDetail}) async {
  //   SharedPreferences prefs = await _initSharedPreferences();
  //   prefs.setString('printerDetail', jsonEncode(printerDetail));
  // }

  // Future<PrinterDetail?> getPrinterDetails() async {
  //   SharedPreferences prefs = await _initSharedPreferences();
  //   String? sessionString = prefs.getString('printerDetail');
  //   if (sessionString != null) {
  //     PrinterDetail session = PrinterDetail.fromJson(jsonDecode(sessionString));
  //     return session;
  //   } else {
  //     return null;
  //   }
  // }

  // Future<bool> clearPrinterSession() async {
  //   SharedPreferences prefs = await _initSharedPreferences();
  //   return prefs.remove('printerDetail');
  // }

  // Future<bool> clearSession() async {
  //   SharedPreferences prefs = await _initSharedPreferences();
  //   return prefs.remove('session');
  // }

  // Future<UserSession?> getSession() async {
  //   SharedPreferences prefs = await _initSharedPreferences();
  //   String? sessionString = prefs.getString('session');
  //   if (sessionString != null) {
  //     UserSession session = UserSession.fromJson(jsonDecode(sessionString));
  //     return session;
  //   } else {
  //     return null;
  //   }
  // }

  // Future<void> setBaseUrl({required String baseUrl}) async {
  //   SharedPreferences prefs = await _initSharedPreferences();
  //   prefs.setString('baseUrl', baseUrl);
  // }

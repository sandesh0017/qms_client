import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

class PrinterDetail {
  int? id;
  String? deviceName;
  String? address;
  String? port;
  String? vendorId;
  String? productId;
  bool? isBle;

  PrinterType typePrinter;
  bool? state;

  PrinterDetail(
      {this.deviceName,
      this.address,
      this.port,
      this.state,
      this.vendorId,
      this.productId,
      this.typePrinter = PrinterType.usb,
      this.isBle = false});

  factory PrinterDetail.fromJson(Map<String, dynamic> json) => PrinterDetail(
        deviceName: json["deviceName"],
        vendorId: json["vendorId"],
        productId: json["productId"],
      );

  Map<String, dynamic> toJson() => {
        "deviceName": deviceName,
        "vendorId": vendorId,
        "productId": productId,
      };
}

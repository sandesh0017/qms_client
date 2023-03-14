import 'dart:async';
import 'dart:io';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:nepali_utils/nepali_utils.dart';

import '../../models/printer_detail.dart';

class PrinterHelper {
  var defaultPrinterType = PrinterType.bluetooth;
  final _isBle = false;
  final _reconnect = false;
  bool isConnected = false;
  var printerManager = PrinterManager.instance;
  var devices = <PrinterDetail>[];
  StreamSubscription<PrinterDevice>? _subscription;
  StreamSubscription<BTStatus>? _subscriptionBtStatus;
  StreamSubscription<USBStatus>? _subscriptionUsbStatus;
  final BTStatus _currentStatus = BTStatus.none;
  // currentUsbStatus is only supports on Android
  // ignore: unused_field
  final USBStatus currentUsbStatus = USBStatus.none;
  List<int>? pendingTask;
  String _ipAddress = '';
  String _port = '9100';
  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  PrinterDetail? selectedPrinter;

  static final PrinterHelper _printerHelper = PrinterHelper._();

  factory PrinterHelper() {
    return _printerHelper;
  }

  PrinterHelper._();

  // initPrinterServices() {
  //   if (Platform.isWindows) defaultPrinterType = PrinterType.usb;
  //   _portController.text = _port;
  //   _scan();

  //   // subscription to listen change status of bluetooth connection
  //   _subscriptionBtStatus =
  //       PrinterManager.instance.stateBluetooth.listen((status) {
  //     log(' ----------------- status bt $status ------------------ ');
  //     _currentStatus = status;
  //     if (status == BTStatus.connected) {
  //       setState(() {
  //         _isConnected = true;
  //       });
  //     }
  //     if (status == BTStatus.none) {
  //       setState(() {
  //         _isConnected = false;
  //       });
  //     }
  //     if (status == BTStatus.connected && pendingTask != null) {
  //       if (Platform.isAndroid) {
  //         Future.delayed(const Duration(milliseconds: 1000), () {
  //           PrinterManager.instance
  //               .send(type: PrinterType.bluetooth, bytes: pendingTask!);
  //           pendingTask = null;
  //         });
  //       } else if (Platform.isIOS) {
  //         PrinterManager.instance
  //             .send(type: PrinterType.bluetooth, bytes: pendingTask!);
  //         pendingTask = null;
  //       }
  //     }
  //   });
  //   //  PrinterManager.instance.stateUSB is only supports on Android
  //   _subscriptionUsbStatus = PrinterManager.instance.stateUSB.listen((status) {
  //     log(' ----------------- status usb $status ------------------ ');
  //     currentUsbStatus = status;
  //     if (Platform.isAndroid) {
  //       if (status == USBStatus.connected && pendingTask != null) {
  //         Future.delayed(const Duration(milliseconds: 1000), () {
  //           PrinterManager.instance
  //               .send(type: PrinterType.usb, bytes: pendingTask!);
  //           pendingTask = null;
  //         });
  //       }
  //     }
  //   });
  // }

  // method to scan devices according PrinterType
  void scan() {
    devices.clear();
    _subscription = printerManager
        .discovery(type: defaultPrinterType, isBle: _isBle)
        .listen((device) {
      devices.add(PrinterDetail(
        deviceName: device.name,
        address: device.address,
        isBle: _isBle,
        vendorId: device.vendorId,
        productId: device.productId,
        typePrinter: defaultPrinterType,
      ));
    });
  }

  void setPort(String value) {
    if (value.isEmpty) value = '9100';
    _port = value;
    var device = PrinterDetail(
      deviceName: value,
      address: _ipAddress,
      port: _port,
      typePrinter: PrinterType.network,
      state: false,
    );
    selectDevice(device);
  }

  void setIpAddress(String value) {
    _ipAddress = value;
    var device = PrinterDetail(
      deviceName: value,
      address: _ipAddress,
      port: _port,
      typePrinter: PrinterType.network,
      state: false,
    );
    selectDevice(device);
  }

  void selectDevice(PrinterDetail device) async {
    if (selectedPrinter != null) {
      if ((device.address != selectedPrinter!.address) ||
          (device.typePrinter == PrinterType.usb &&
              selectedPrinter!.vendorId != device.vendorId)) {
        await PrinterManager.instance
            .disconnect(type: selectedPrinter!.typePrinter);
      }
    }

    selectedPrinter = device;
    //BluetoothPrinter in storage
    //save this instance to storage
  }

  Future printReceiveTest(
      {String? currentToken, String service = 'No token'}) async {
    List<int> bytes = [];

    // Xprinter XP-N160I
    final profile = await CapabilityProfile.load(name: 'CP1252');
    // PaperSize.mm80 or PaperSize.mm58
    if (currentToken == null) return;
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.setGlobalCodeTable('UTF8');
    bytes += generator.text(NepaliUnicode.convert("sayau' thu"),
        linesAfter: 2,
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    bytes += generator.text('पोखरा, गण्डकी प्रदेश, नेपाल',
        linesAfter: 2,
        styles: const PosStyles(
            codeTable: 'U+0900..U+097F',
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));

    _printEscPos(bytes, generator);
  }

  /// print ticket
  void _printEscPos(List<int> bytes, Generator generator) async {
    if (selectedPrinter == null) _connectDevice();
    if (selectedPrinter == null) return;
    var bluetoothPrinter = selectedPrinter!;

    switch (bluetoothPrinter.typePrinter) {
      case PrinterType.usb:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model: UsbPrinterInput(
                name: bluetoothPrinter.deviceName,
                productId: bluetoothPrinter.productId,
                vendorId: bluetoothPrinter.vendorId));
        pendingTask = null;
        break;
      case PrinterType.bluetooth:
        bytes += generator.cut();
        await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model: BluetoothPrinterInput(
                name: bluetoothPrinter.deviceName,
                address: bluetoothPrinter.address!,
                isBle: bluetoothPrinter.isBle ?? false,
                autoConnect: _reconnect));
        pendingTask = null;
        if (Platform.isAndroid) pendingTask = bytes;
        break;
      case PrinterType.network:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model: TcpPrinterInput(ipAddress: bluetoothPrinter.address!));
        break;
      default:
    }
    if (bluetoothPrinter.typePrinter == PrinterType.bluetooth &&
        Platform.isAndroid) {
      if (_currentStatus == BTStatus.connected) {
        printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
        pendingTask = null;
      }
    } else {
      printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
    }
  }

  // conectar dispositivo
  _connectDevice() async {
    isConnected = false;
    if (selectedPrinter == null) {
      return;
    }
    switch (selectedPrinter!.typePrinter) {
      case PrinterType.usb:
        await printerManager
            .connect(
                type: selectedPrinter!.typePrinter,
                model: UsbPrinterInput(
                    name: selectedPrinter!.deviceName,
                    productId: selectedPrinter!.productId,
                    vendorId: selectedPrinter!.vendorId))
            .then((result) {
          if (!result) {
            //open configuratino page
          }
        });
        isConnected = true;
        break;
      case PrinterType.bluetooth:
        await printerManager.connect(
            type: selectedPrinter!.typePrinter,
            model: BluetoothPrinterInput(
                name: selectedPrinter!.deviceName,
                address: selectedPrinter!.address!,
                isBle: selectedPrinter!.isBle ?? false,
                autoConnect: _reconnect));
        break;
      case PrinterType.network:
        await printerManager.connect(
            type: selectedPrinter!.typePrinter,
            model: TcpPrinterInput(ipAddress: selectedPrinter!.address!));
        isConnected = true;
        break;
      default:
    }
  }

  void disconnect() {
    _subscription?.cancel();
    _subscriptionBtStatus?.cancel();
    _subscriptionUsbStatus?.cancel();
    _portController.dispose();
    _ipController.dispose();
  }
}

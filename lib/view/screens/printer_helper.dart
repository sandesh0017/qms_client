import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:intl/intl.dart';

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
      {String currentToken = 'CS-10002', String? service}) async {
    final DateTime now = DateTime.now();
    final DateFormat xdate = DateFormat('yyyy-MM-dd');
    final String date = xdate.format(now);
    String time = DateFormat("hh:mm:ss").format(now);
    List<int> bytes = [];

    // Xprinter XP-N160I
    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    // PaperSize.mm80 or PaperSize.mm58
    if (currentToken == null) return;
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.setGlobalCodeTable('CP1252');
    // bytes += generator.text(
    //     utf8.encode(
    //       'भाषामा',
    //     ) as String ,
    //     linesAfter: 0,
    //     styles: const PosStyles(
    //         align: PosAlign.center,
    //         height: PosTextSize.size2,
    //         width: PosTextSize.size1));
    bytes += generator.text('Transport Management Office',
        linesAfter: 0,
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size1));
    bytes += generator.text('Pokhara, Gandaki Province, Nepal',
        linesAfter: 1,
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    bytes += generator.text('DateTime : $date $time',
        linesAfter: 1,
        styles: const PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size7,
            width: PosTextSize.size7));
    bytes += generator.text('Your Token Number:',
        linesAfter: 0,
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size5,
            width: PosTextSize.size5));
    bytes += generator.text(currentToken,
        linesAfter: 1,
        styles: const PosStyles(

            // bold: true,
            align: PosAlign.center,
            height: PosTextSize.size3,
            width: PosTextSize.size3));
    bytes += generator.text('No Service',
        linesAfter: 1,
        styles: PosStyles(
            fontType: PosFontType.values.first,
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    bytes += generator.text('Thanks for comming !',
        linesAfter: 0,
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1));
    // String assetName = 'assets/images/logoo.jpg';
    // Uint8List imageBytes = await getImageAssetByteData(assetName);
    // final image = await ImageLoader.loadFromMemory(imageData);
    // print(imageBytes);
    // Image image = Image.memory(imageBytes);
    // Using `ESC *`//=================================================================
// final ByteData logoBytes = await rootBundle.load('assets/logo.jpg');
//     receiptText.addImage(
//       base64.encode(Uint8List.view(logoBytes.buffer)),
//       width: 150,
//     );

    final ByteData data = await rootBundle.load('assets/logo.png');
    final Uint8List imgBytes = data.buffer.asUint8List();
    final Image image = decodeImage(imgBytes)!;
    bytes += generator.image(image);
// bytes += generator.image();
    //

    _printEscPos(bytes, generator);
  }

  Future<Uint8List> getImageAssetByteData(String assetName) async {
    final byteData = await rootBundle.load(assetName);
    return byteData.buffer.asUint8List();
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

  String toNepali(String input) {
    final Map<String, String> nepaliDigits = {
      '0': 'o',
      '1': '१',
      '2': '२',
      '3': '३',
      '4': '४',
      '5': '५',
      '6': '६',
      '7': '७',
      '8': '८',
      '9': '९',
    };

    final List<String> parts = input.split('-');
    log('parts==>$parts');
    final StringBuffer buffer = StringBuffer();
    log('buffer==>$buffer');

    var writebufffer = buffer.write(parts[0]);
    buffer.write('-');

    final String digits = parts[1];
    log('digitsssss$digits');
    for (int i = 0; i < digits.length; i++) {
      final String digit = digits[i];
      log('digit$digit');
      buffer.write(nepaliDigits[digit]);
    }
    log('bufferTOOSTring${buffer.toString()}');
    return buffer.toString();
  }
}

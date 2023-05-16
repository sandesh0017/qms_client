import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:qms_client/core/constants/colors.dart';
import 'package:qms_client/view/screens/service_offered_screen.dart';

import '../../core/local/shared_prefence.dart';
import '../../models/printer_detail.dart';

late GlobalKey<PosPrinterScreenState> printKey;

class PosPrinterScreen extends StatefulWidget {
  const PosPrinterScreen({Key? key}) : super(key: key);

  @override
  State<PosPrinterScreen> createState() => PosPrinterScreenState();
}

class PosPrinterScreenState extends State<PosPrinterScreen> {
  // Printer Type [bluetooth, usb, network]
  var defaultPrinterType = PrinterType.bluetooth;
  var _isBle = false;
  var _reconnect = false;
  var _isConnected = false;
  var printerManager = PrinterManager.instance;
  var devices = <PrinterDetail>[];
  StreamSubscription<PrinterDevice>? _subscription;
  StreamSubscription<BTStatus>? _subscriptionBtStatus;
  StreamSubscription<USBStatus>? _subscriptionUsbStatus;
  BTStatus _currentStatus = BTStatus.none;
  // _currentUsbStatus is only supports on Android
  // ignore: unused_field
  USBStatus _currentUsbStatus = USBStatus.none;
  List<int>? pendingTask;
  String _ipAddress = '';
  String _port = '9100';
  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  PrinterDetail? selectedPrinter;

  var latestPrinter = SessionPreferences().getPrinterDetails();
  @override
  void initState() {
    printKey = GlobalKey();
    if (Platform.isWindows) defaultPrinterType = PrinterType.usb;
    super.initState();
    _portController.text = _port;
    _scan();

    // subscription to listen change status of bluetooth connection
    _subscriptionBtStatus =
        PrinterManager.instance.stateBluetooth.listen((status) {
      log(' ----------------- status bt $status ------------------ ');
      _currentStatus = status;
      if (status == BTStatus.connected) {
        setState(() {
          _isConnected = true;
        });
      }
      if (status == BTStatus.none) {
        setState(() {
          _isConnected = false;
        });
      }
      if (status == BTStatus.connected && pendingTask != null) {
        if (Platform.isAndroid) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            PrinterManager.instance
                .send(type: PrinterType.bluetooth, bytes: pendingTask!);
            pendingTask = null;
          });
        } else if (Platform.isIOS) {
          PrinterManager.instance
              .send(type: PrinterType.bluetooth, bytes: pendingTask!);
          pendingTask = null;
        }
      }
    });
    //  PrinterManager.instance.stateUSB is only supports on Android
    _subscriptionUsbStatus = PrinterManager.instance.stateUSB.listen((status) {
      log(' ----------------- status usb $status ------------------ ');
      _currentUsbStatus = status;
      if (Platform.isAndroid) {
        if (status == USBStatus.connected && pendingTask != null) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            PrinterManager.instance
                .send(type: PrinterType.usb, bytes: pendingTask!);
            pendingTask = null;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscriptionBtStatus?.cancel();
    _subscriptionUsbStatus?.cancel();
    _portController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  // method to scan devices according PrinterType
  void _scan() {
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
      setState(() {});
      log('pid$device');
      log('vid${device.vendorId}');
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
    setState(() {});
  }

  Future printReceiveTest({String? currentToken}) async {
    List<int> bytes = [];

    // Xprinter XP-N160I
    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm58, profile);
    // bytes += generator.setGlobalCodeTable('U+A8E0–U+A8FF');
    // bytes += generator.text('Your Token is:',
    //     linesAfter: 2,
    //     styles: const PosStyles(
    //         align: PosAlign.center,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1));
    // bytes += generator.text(currentToken ?? 'CS-100',
    //     styles: const PosStyles(
    //         // bold: true,
    //         align: PosAlign.center,
    //         height: PosTextSize.size3,
    //         width: PosTextSize.size3));
    bytes += generator.text('TEst',
        linesAfter: 2,
        styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            // codeTable: 'UTF8',
            width: PosTextSize.size1));
    // bytes += generator.text('पोखरा, गण्डकी प्रदेश, नेपाल',
    //     linesAfter: 2,
    //     styles: const PosStyles(
    //         align: PosAlign.center,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1));
    // bytes += generator.text('2020-01-12   04:55 pm',
    //     linesAfter: 2,
    //     styles: const PosStyles(
    //         align: PosAlign.center,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1));
    // bytes += generator.text('टोकन नम्बर :',
    //     linesAfter: 2,
    //     styles: const PosStyles(
    //         align: PosAlign.center,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1));
    // bytes += generator.text(currentToken ?? 'CS-100',
    //     styles: const PosStyles(
    //         // bold: true,
    //         align: PosAlign.center,
    //         height: PosTextSize.size3,
    //         width: PosTextSize.size3));
    // bytes += generator.text('टोकन नम्बर :',
    //     linesAfter: 2,
    //     styles: const PosStyles(
    //         align: PosAlign.center,
    //         height: PosTextSize.size1,
    //         width: PosTextSize.size1));

    _printEscPos(bytes, generator);
  }

  /// print ticket
  void _printEscPos(List<int> bytes, Generator generator) async {
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
    _isConnected = false;
    if (selectedPrinter == null) return;
    switch (selectedPrinter!.typePrinter) {
      case PrinterType.usb:
        await printerManager.connect(
            type: selectedPrinter!.typePrinter,
            model: UsbPrinterInput(
                name: selectedPrinter!.deviceName,
                productId: selectedPrinter!.productId,
                vendorId: selectedPrinter!.vendorId));
        _isConnected = true;
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
        _isConnected = true;
        break;
      default:
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: printKey,
      appBar: AppBar(
        toolbarHeight: 100,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ServiceOfferedScreen()));
            },
            icon: const Icon(Icons.chevron_left)),
        title: Text(
          'Select Printer',
          style: TextStyle(color: AppColor.primaryColor, fontSize: 28),
        ),
        actions: [
          if (latestPrinter != null)
            Text(
              // '${selectedPrinter!.deviceName
              // }      ',
              '$latestPrinter',
              style: TextStyle(color: Colors.grey.shade200),
            )
          else
            Text(
              'not Select',
              style: TextStyle(color: Colors.grey.shade200),
            ),
          IconButton(
              onPressed: () async {
                await SessionPreferences().clearPrinterSession();
              },
              icon: const Icon(Icons.clear)),
        ],
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          height: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedPrinter == null || _isConnected
                              ? null
                              : () {
                                  _connectDevice();
                                },
                          child: const Text("Connect",
                              textAlign: TextAlign.center),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedPrinter == null || !_isConnected
                              ? null
                              : () {
                                  if (selectedPrinter != null) {
                                    printerManager.disconnect(
                                        type: selectedPrinter!.typePrinter);
                                  }
                                  setState(() {
                                    _isConnected = false;
                                  });
                                },
                          child: const Text("Disconnect",
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField<PrinterType>(
                  value: defaultPrinterType,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.print,
                      size: 24,
                    ),
                    labelText: "Type Printer Device",
                    labelStyle: TextStyle(fontSize: 18.0),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  items: <DropdownMenuItem<PrinterType>>[
                    if (Platform.isAndroid || Platform.isIOS)
                      const DropdownMenuItem(
                        value: PrinterType.bluetooth,
                        child: Text("bluetooth"),
                      ),
                    if (Platform.isAndroid || Platform.isWindows)
                      const DropdownMenuItem(
                        value: PrinterType.usb,
                        child: Text("usb"),
                      ),
                    const DropdownMenuItem(
                      value: PrinterType.network,
                      child: Text("Wifi"),
                    ),
                  ],
                  onChanged: (PrinterType? value) {
                    setState(() {
                      if (value != null) {
                        setState(() {
                          defaultPrinterType = value;
                          selectedPrinter = null;
                          _isBle = false;
                          _isConnected = false;
                          _scan();
                        });
                      }
                    });
                  },
                ),
                Visibility(
                  visible: defaultPrinterType == PrinterType.bluetooth &&
                      Platform.isAndroid,
                  child: SwitchListTile.adaptive(
                    contentPadding:
                        const EdgeInsets.only(bottom: 20.0, left: 20),
                    title: const Text(
                      "This device supports ble (low energy)",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 19.0),
                    ),
                    value: _isBle,
                    onChanged: (bool? value) {
                      setState(() {
                        _isBle = value ?? false;
                        _isConnected = false;
                        selectedPrinter = null;
                        _scan();
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: defaultPrinterType == PrinterType.bluetooth &&
                      Platform.isAndroid,
                  child: SwitchListTile.adaptive(
                    contentPadding:
                        const EdgeInsets.only(bottom: 20.0, left: 20),
                    title: const Text(
                      "reconnect",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 19.0),
                    ),
                    value: _reconnect,
                    onChanged: (bool? value) {
                      setState(() {
                        _reconnect = value ?? false;
                      });
                    },
                  ),
                ),
                Column(
                    children: devices
                        .map(
                          (device) => ListTile(
                            title: Text('${device.deviceName}'),
                            subtitle: Platform.isAndroid &&
                                    defaultPrinterType == PrinterType.usb
                                ? null
                                : Visibility(
                                    visible: !Platform.isWindows,
                                    child: Text("${device.address}")),
                            onTap: () async {
                              selectDevice(device);
                              await SessionPreferences()
                                  .setPrinterDetails(printerDetail: device);
                            },
                            leading: selectedPrinter != null &&
                                    ((device.typePrinter == PrinterType.usb &&
                                                Platform.isWindows
                                            ? device.deviceName ==
                                                selectedPrinter!.deviceName
                                            : device.vendorId != null &&
                                                selectedPrinter!.vendorId ==
                                                    device.vendorId) ||
                                        (device.address != null &&
                                            selectedPrinter!.address ==
                                                device.address))
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : null,
                            trailing: OutlinedButton(
                              onPressed: selectedPrinter == null ||
                                      device.deviceName !=
                                          selectedPrinter?.deviceName
                                  ? null
                                  : () async {
                                      printReceiveTest();
                                    },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 20),
                                child: Text("Print test ticket",
                                    textAlign: TextAlign.center),
                              ),
                            ),
                          ),
                        )
                        .toList()),
                Visibility(
                  visible: defaultPrinterType == PrinterType.network &&
                      Platform.isWindows,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      controller: _ipController,
                      keyboardType:
                          const TextInputType.numberWithOptions(signed: true),
                      decoration: const InputDecoration(
                        label: Text("Ip Address"),
                        prefixIcon: Icon(Icons.wifi, size: 24),
                      ),
                      onChanged: setIpAddress,
                    ),
                  ),
                ),
                Visibility(
                  visible: defaultPrinterType == PrinterType.network &&
                      Platform.isWindows,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      controller: _portController,
                      keyboardType:
                          const TextInputType.numberWithOptions(signed: true),
                      decoration: const InputDecoration(
                        label: Text("Port"),
                        prefixIcon: Icon(Icons.numbers_outlined, size: 24),
                      ),
                      onChanged: setPort,
                    ),
                  ),
                ),
                Visibility(
                  visible: defaultPrinterType == PrinterType.network &&
                      Platform.isWindows,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: OutlinedButton(
                      onPressed: () async {
                        if (_ipController.text.isNotEmpty) {
                          setIpAddress(_ipController.text);
                        }
                        printReceiveTest();
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 50),
                        child: Text("Print test ticket",
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

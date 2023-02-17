// import 'dart:developer';

// // import 'package:blue_thermal_printer/blue_thermal_printer.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:bluetooth_print/bluetooth_print.dart' as a;

// // import 'package:flutter_bluetooth/utils/print_sample.dart';

// class Printer {

//   //instance of bluetooth printer
//   BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
//   a.BluetoothPrint bluetoothPrint = a.BluetoothPrint.instance;

//   //list of bluetooth devices
//   List<BluetoothDevice> _devices = [];
//   BluetoothDevice? _device;
//   //connection status
//   bool _connected = false;
//   //instance of sample bluetooth print
//   PrintSample printSample = PrintSample();

//     Future<void> initPlatformState() async {
//     bool? isConnected = await bluetooth.isConnected;
//     List<BluetoothDevice> devices = [];
//     try {
//       devices = await bluetooth.getBondedDevices();
//     } on PlatformException {}

//     bluetooth.onStateChanged().listen((state) {
//       switch (state) {
//         case BlueThermalPrinter.CONNECTED:
//           setState(() {
//             _connected = true;
//             print("bluetooth device state: connected");
//           });
//           break;
//         case BlueThermalPrinter.DISCONNECTED:
//           setState(() {
//             _connected = false;
//             print("bluetooth device state: disconnected");
//           });
//           break;
//         case BlueThermalPrinter.DISCONNECT_REQUESTED:
//           setState(() {
//             _connected = false;
//             print("bluetooth device state: disconnect requested");
//           });
//           break;
//         case BlueThermalPrinter.STATE_TURNING_OFF:
//           setState(() {
//             _connected = false;
//             print("bluetooth device state: bluetooth turning off");
//           });
//           break;
//         case BlueThermalPrinter.STATE_OFF:
//           setState(() {
//             _connected = false;
//             print("bluetooth device state: bluetooth off");
//           });
//           break;
//         case BlueThermalPrinter.STATE_ON:
//           setState(() {
//             _connected = false;
//             print("bluetooth device state: bluetooth on");
//           });
//           break;
//         case BlueThermalPrinter.STATE_TURNING_ON:
//           setState(() {
//             _connected = false;
//             print("bluetooth device state: bluetooth turning on");
//           });
//           break;
//         case BlueThermalPrinter.ERROR:
//           setState(() {
//             _connected = false;
//             print("bluetooth device state: error");
//           });
//           break;
//         default:
//           print(state);
//           break;
//       }
//     });

//     if (!mounted) return;
//     setState(() {
//       _devices = devices;
//     });

//     if (isConnected == true) {
//       setState(() {
//         _connected = true;
//       });
//     }
//   }

// }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   initPlatformState();
//   // }

//   //initializing bluetooth

//   void _connect() {
//     if (_device != null) {
//       bluetooth.isConnected.then((isConnected) {
//         if (isConnected!) {
//           setState(() {
//             _connected = true;
//           });
//         } else {
//           bluetooth.connect(_device!).then((value) {
//             log("$value asd");
//             setState(() => _connected = true);
//           }).catchError((error) {
//             show('Device Already Connected. $error', context: context);
//             setState(() => _connected = false);
//           });
//         }
//       });
//     } else {
//       show('No device selected.', context: context);
//     }
//   }

//   void _disconnect() {
//     bluetooth.disconnect();
//     setState(() => _connected = false);
//   }

//   List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
//     List<DropdownMenuItem<BluetoothDevice>> items = [];
//     if (_devices.isEmpty) {
//       items.add(const DropdownMenuItem(child: Text('NONE')));
//     } else {
//       for (var device in _devices) {
//         items.add(
//             DropdownMenuItem(value: device, child: Text(device.name ?? "")));
//       }
//     }
//     return items;
//   }

//   Future show(String message,
//       {Duration duration = const Duration(seconds: 3), context}) async {
//     await Future.delayed(const Duration(milliseconds: 100));
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(message, style: const TextStyle(color: Colors.white)),
//         duration: duration));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: const Text('Blue Thermal Printer')),
//         body: Container(
//             child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ListView(children: <Widget>[
//                   Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: <Widget>[
//                         const SizedBox(width: 10),
//                         const Text('Device:',
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                         const SizedBox(width: 30),
//                         Expanded(
//                             child: DropdownButton(
//                                 items: _getDeviceItems(),
//                                 onChanged: (value) =>
//                                     setState(() => _device = value),
//                                 value: _device))
//                       ]),
//                   const SizedBox(height: 10),
//                   Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: <Widget>[
//                         ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.brown),
//                             onPressed: () {
//                               initPlatformState();
//                             },
//                             child: const Text('Refresh',
//                                 style: TextStyle(color: Colors.white))),
//                         const SizedBox(width: 20),
//                         ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor:
//                                     _connected ? Colors.red : Colors.green),
//                             onPressed: _connected ? _disconnect : _connect,
//                             child: Text(_connected ? 'Disconnect' : 'Connect',
//                                 style: const TextStyle(color: Colors.white)))
//                       ]),
//                   Padding(
//                       padding: const EdgeInsets.only(
//                           left: 10.0, right: 10.0, top: 50),
//                       child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.brown),
//                           onPressed: () {
//                             printSample.printToken();
//                           },
//                           child: const Text('PRINT TEST',
//                               style: TextStyle(color: Colors.white))))
//                 ]))));
//   }
// }

import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class PrintSample {
  sample({String? tokenNum}) async {
    BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printCustom(
            '===============================================================',
            0,
            0);
        bluetooth.printCustom(
            '***************************************************************',
            0,
            0);
        bluetooth.printCustom('NIC ASIA', 3, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();

        bluetooth.printCustom(tokenNum!, 4, 1);
        bluetooth.printNewLine();

        bluetooth.printQRcode(tokenNum, 200, 200, 1);
        bluetooth.printCustom(
            '**************************************************************',
            0,
            0);
        bluetooth.printCustom(
            '===============================================================',
            0,
            0);

        bluetooth.paperCut();
      }
    });
  }

  printToken({String? tokenNum}) {
    BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

    bluetooth.isConnected.then((value) {
      bluetooth.printCustom(tokenNum!, 55, 100);
      bluetooth.paperCut();
    });
  }
}

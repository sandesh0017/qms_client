// import 'package:bluetooth_print/bluetooth_print.dart';
// import 'package:bluetooth_print/bluetooth_print_model.dart';
// import 'package:flutter/material.dart';

// class PrintPage extends StatefulWidget {
//   const PrintPage({super.key});

//   @override
//   State<PrintPage> createState() => _PrintPageState();
// }

// class _PrintPageState extends State<PrintPage> {
//   BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
//   List<BluetoothDevice> _devices = [];
//   String _devicesMsg = '';

//   @override
//   void initState() {
//     super.initState();
//     initPrinter();
//   }

//   Future<void> initPrinter() async {
//     bluetoothPrint.startScan(timeout: const Duration(seconds: 1));

//     if (!mounted) return;
//     bluetoothPrint.scanResults.listen((event) {
//       if (!mounted) return;
//       setState(() {
//         _devices = event;
//       });
//       if (_devices.isEmpty) {
//         setState(() {
//           _devicesMsg = 'No Devices';
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _devices.isEmpty
//           ? Center(child: Text(_devicesMsg))
//           : ListView.builder(
//               itemCount: _devices.length,
//               itemBuilder: (c, i) {
//                 return ListTile(
//                   leading: const Icon(Icons.print),
//                   title: Text(_devices[i].name!),
//                   subtitle: Text(_devices[i].address!),
//                   onTap: () {
//                     _startPrint(_devices[i]);
//                   },
//                 );
//               }),
//     );
//   }
// }

// Future<void> _startPrint(BluetoothDevice? device) async {
//   if (device != null && device.address != null) {
//     Map<String, dynamic> config = {};
//     List<LineText> printList = [];

//     printList.add(LineText(content: 'Title'));
//   }
// }

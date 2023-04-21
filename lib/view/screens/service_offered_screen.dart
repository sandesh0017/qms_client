// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qms_client/core/constants/colors.dart';
import 'package:qms_client/core/local/shared_prefence.dart';
import 'package:qms_client/core/utils/show_custom_snack_bar.dart';
import 'package:qms_client/view/screens/pos_printer_screen.dart';
import 'package:qms_client/view/screens/printer_helper.dart';
import 'package:qms_client/view/widgets/alert_dialog.dart';

import '../../models/data_model_model.dart';
import '../../services/service_offered_services.dart';
import '../widgets/custom_button.dart';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class ServiceOfferedScreen extends StatefulWidget {
  const ServiceOfferedScreen({super.key});

  @override
  State<ServiceOfferedScreen> createState() => ServiceOfferedScreenState();
}

class ServiceOfferedScreenState extends State<ServiceOfferedScreen> {
  List<DataModel> serviceOfferedList = [];
  String? currentToken = '';
  int? serviceCentreIdCodeLocal;
  String? serviceCentreLocal;
  int? kioskIdLocal;
  int? serviceOfferedIdLocal;
  String? serviceCentreName;
  SessionPreferences sessionPreferences = SessionPreferences();
  bool receiveNewToken = true;

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  //list of bluetooth devices
  final List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  //connection status
  final bool _connected = false;
  //instance of sample bluetooth print
  // PrintSample printSample = PrintSample();
  PrinterHelper printerHelper = PrinterHelper();
/////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    // printerHelper.scan();
    //printerHelper.selectedPrinter
    //pinter connection huna paryo

    getSession().then((value) {
      return getServiceOffered(kioskIdLocal!);
    });
    getPrinterDetails();
  }

  Future<void> getSession() async {
    var session = await sessionPreferences.getSession();
    serviceCentreIdCodeLocal = session!.serviceCentreCode;
    serviceCentreLocal = session.serviceCentreName;
    kioskIdLocal = int.parse(session.koiskIdCode!);
  }

  Future<void> getPrinterDetails() async {
    printerHelper.scan();
    var printerDetail = await sessionPreferences.getPrinterDetails();
    if (printerDetail == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const PosPrinterScreen()));
      });
    }
    printerHelper.selectedPrinter = printerDetail;
  }

  Future<void> getServiceOffered(int kioskId) async {
    try {
      var result = await ServiceOfferedServices().getServiceOffered(kioskId);
      if (result.data != null) {
        setState(() {
          serviceOfferedList.addAll(result.data!);
        });
      } else {
        showCustomSnackBar(context, 'No Services');
      }
    } catch (e) {
      showCustomSnackBar(context, e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> getNewTokenNumber(
      int serviceCentreId, int kioskId, int serviceOffereId) async {
    try {
      var result = await ServiceOfferedServices()
          .getNewTokenNumber(serviceCentreId, kioskId, serviceOffereId);
      if (result.data != null) {
        setState(() {
          currentToken = result.data!;
        });
      } else {
        setState(() {
          currentToken = result.data!;
        });
      }
    } catch (e) {
      showCustomSnackBar(context, e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 200,
        toolbarHeight: 150,
        backgroundColor: AppColor.secondaryColor,
        leading: SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/police.png',
              // scale: 1.,
            ),
          ),
        ),
        centerTitle: true,
        title: RichText(
            textAlign: TextAlign.center,
            // textDirection: ,
            text: const TextSpan(
                text: 'नेपाल प्रहरी अस्पताल\n',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
                children: [
                  // TextSpan(
                  //   text: '"सत्य, सेवा सुरक्षणम्"',
                  //   style: TextStyle(color: Colors.white, fontSize: 16),
                  // ),
                  TextSpan(
                    text: '"सत्य, सेवा सुरक्षणम्"',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ])),
        actions: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Image.asset('assets/animations/flag.gif'),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(children: [
          Container(
            margin: EdgeInsets.only(
                left: size.width * 0.1,
                right: size.width * 0.1,
                bottom: 20,
                top: 20),
            decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black38, blurRadius: 15, spreadRadius: 5),
                ],
                borderRadius: BorderRadius.circular(25)),
            child: Container(
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'Services',
                        style: TextStyle(color: Colors.black87, fontSize: 30),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: size.height * 0.7,
                        width: size.width * 0.75,
                        child: serviceOfferedList.isNotEmpty
                            ? GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 2.2,
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 20,
                                        crossAxisSpacing: 40),
                                itemCount: serviceOfferedList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return BouncingButton(
                                    serviceOfferedList:
                                        serviceOfferedList[index],
                                    filledColor: AppColor.primaryColor,
                                    text: serviceOfferedList[index].name,
                                    radius: 20,
                                    onTap: receiveNewToken
                                        ? () async {
                                            receiveNewToken = false;
                                            if (printerHelper.selectedPrinter !=
                                                null) {
                                              await getNewTokenNumber(
                                                  serviceCentreIdCodeLocal!,
                                                  kioskIdLocal!,
                                                  serviceOfferedList[index].id);
                                              printerHelper.printReceiveTest(
                                                  currentToken:
                                                      currentToken ?? 'CS-0000',
                                                  service:
                                                      serviceOfferedList[index]
                                                          .name);
                                              receiveNewToken = true;
                                            } else {
                                              receiveNewToken = true;
                                              showCustomSnackBar(context,
                                                  'No Printers Connected!',
                                                  taskSuccess: false);
                                            }
                                          }
                                        //////////////
                                        : () {},
                                  );
                                },
                              )
                            : const Center(child: CircularProgressIndicator()),
                      ),
                      // Text(' Current Token ===>>> $currentToken',
                      //     style: const TextStyle(fontSize: 40)),
                      // Text(' service centre ===>>> $serviceCentreIdCodeLocal'),
                      // DropdownButton(
                      //     items: _getDeviceItems(),
                      //     onChanged: (value) => setState(() => _device = value),
                      //     value: _device),
                      // Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: <Widget>[
                      //       ElevatedButton(
                      //           style: ElevatedButton.styleFrom(
                      //               backgroundColor: Colors.brown),
                      //           onPressed: () {
                      //             // initPlatformState();
                      //           },
                      //           child: const Text('Refresh',
                      //               style: TextStyle(color: Colors.white))),
                      //       const SizedBox(width: 20),
                      //       ElevatedButton(
                      //           style: ElevatedButton.styleFrom(
                      //               backgroundColor:
                      //                   _connected ? Colors.red : Colors.green),
                      //           onPressed: _connected ? _disconnect : _connect,
                      //           child: Text(_connected ? 'Disconnect' : 'Connect',
                      //               style: const TextStyle(color: Colors.white)))
                      //     ]),
                      // TextButton.icon(
                      //   onPressed: () {
                      //     printSample.sample(tokenNum: currentToken ?? 'C 100 ');
                      //   },
                      //   icon: const Icon(Icons.print),
                      //   label: const Text('Print'),
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              right: 30,
              top: 20,
              child: IconButton(
                // padding: const EdgeInsets.fromLTRB(0, 40, 50, 0),
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  logOutOnPress(context);
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (_) => const ConfigureScreen()));
                  // await SessionPreferences().clearSession();
                },
                iconSize: 32,
              )),
          Positioned(
              right: 30,
              bottom: 20,
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PosPrinterScreen()));
                  },
                  icon: const Icon(Icons.print))),
          Positioned(
              right: 42,
              bottom: 80,
              child: Text(
                currentToken!,
                style: TextStyle(color: Colors.grey.shade300),
              ))
        ]),
      ),
    );
  }

///////////////////////////////////////////////////////////////////////
  ///
  ///
  //initializing bluetooth

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
// }
}

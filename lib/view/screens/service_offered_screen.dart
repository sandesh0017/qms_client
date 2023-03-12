import 'package:flutter/material.dart';
import 'package:qms_client/core/constants/colors.dart';
import 'package:qms_client/core/local/shared_prefence.dart';
import 'package:qms_client/core/utils/show_custom_snack_bar.dart';
import 'package:qms_client/view/widgets/alert_dialog.dart';

import '../../models/data_model_model.dart';
import '../../services/service_offered_services.dart';
import '../widgets/custom_button.dart';
import 'dart:developer';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import '../screens/print.dart';

class ServiceOfferedScreen extends StatefulWidget {
  const ServiceOfferedScreen({super.key});

  @override
  State<ServiceOfferedScreen> createState() => ServiceOfferedScreenState();
}

class ServiceOfferedScreenState extends State<ServiceOfferedScreen> {
  List<DataModel> serviceOfferedList = [];
  String? currentToken = '0';
  int? serviceCentreIdCodeLocal;
  String? serviceCentreLocal;
  int? kioskIdLocal;
  int? serviceOfferedIdLocal;
  String? serviceCentreName;
  SessionPreferences sessionPreferences = SessionPreferences();

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  //list of bluetooth devices
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  //connection status
  bool _connected = false;
  //instance of sample bluetooth print
  PrintSample printSample = PrintSample();

/////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    getSession().then((value) {
      return getServiceOffered(kioskIdLocal!);
    });
  }

  Future<void> getSession() async {
    var session = await sessionPreferences.getSession();
    setState(() {
      serviceCentreIdCodeLocal = session!.serviceCentreCode;
      serviceCentreLocal = session.serviceCentreName;
      kioskIdLocal = int.parse(session.koiskIdCode!);
    });
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
        leadingWidth: 300,
        toolbarHeight: 150,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Center(
            child: RichText(
              text: TextSpan(
                  text: 'Branch : ',
                  style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 25,
                      color: Colors.black87),
                  children: [
                    TextSpan(
                      text: serviceCentreLocal,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 27,
                          color: Colors.black87),
                    )
                  ]),
            ),
          ),
        ),
        centerTitle: true,
        title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onDoubleTap: () async {},
                child: SizedBox(
                  height: 110,
                  child: Image.asset(
                    'assets/images/logoo.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
              )
            ]),
        actions: [
          IconButton(
            padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
            icon: const Icon(Icons.logout),
            onPressed: () async {
              logOutOnPress(context);
            },
            iconSize: 32,
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
              left: size.width * 0.1, right: size.width * 0.1, bottom: 20),
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
                    Text(
                      'Services' '           $currentToken',
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 30),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: size.height * 0.6,
                      width: size.width * 0.7,
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
                                  serviceOfferedList: serviceOfferedList[index],
                                  filledColor: AppColor.primaryColor,
                                  text: serviceOfferedList[index].name,
                                  radius: 20,
                                  onTap: () async {
                                    var result = await getNewTokenNumber(
                                        serviceCentreIdCodeLocal!,
                                        kioskIdLocal!,
                                        serviceOfferedList[index].id);
                                    printSample.sample(
                                        tokenNum: currentToken ?? 'No Token ');
                                  },
                                );
                              },
                            )
                          : const Center(child: CircularProgressIndicator()),
                    ),
                    // Text(' Current Token ===>>> $currentToken',
                    //     style: const TextStyle(fontSize: 40)),
                    // Text(' service centre ===>>> $serviceCentreIdCodeLocal'),
                    DropdownButton(
                        items: _getDeviceItems(),
                        onChanged: (value) => setState(() => _device = value),
                        value: _device),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown),
                              onPressed: () {
                                initPlatformState();
                              },
                              child: const Text('Refresh',
                                  style: TextStyle(color: Colors.white))),
                          const SizedBox(width: 20),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      _connected ? Colors.red : Colors.green),
                              onPressed: _connected ? _disconnect : _connect,
                              child: Text(_connected ? 'Disconnect' : 'Connect',
                                  style: const TextStyle(color: Colors.white)))
                        ]),
                    TextButton.icon(
                      onPressed: () {
                        printSample.sample(tokenNum: currentToken ?? 'C 100 ');
                      },
                      icon: const Icon(Icons.print),
                      label: const Text('Print'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////////////////
  ///
  ///
  //initializing bluetooth
  Future<void> initPlatformState() async {
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            print("bluetooth device state: connected");
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnected");
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnect requested");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning off");
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth off");
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth on");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning on");
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
            print("bluetooth device state: error");
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected == true) {
      setState(() {
        _connected = true;
      });
    }
  }

  void _connect() {
    if (_device != null) {
      bluetooth.isConnected.then((isConnected) {
        if (isConnected!) {
          setState(() {
            _connected = true;
          });
        } else {
          bluetooth.connect(_device!).then((value) {
            log("$value asd");
            setState(() => _connected = true);
          }).catchError((error) {
            show('Device Already Connected. $error', context: context);
            setState(() => _connected = false);
          });
        }
      });
    } else {
      show('No device selected.', context: context);
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(const DropdownMenuItem(child: Text('NONE')));
    } else {
      for (var device in _devices) {
        items.add(
            DropdownMenuItem(value: device, child: Text(device.name ?? "")));
      }
    }
    return items;
  }

  Future show(String message,
      {Duration duration = const Duration(seconds: 3), context}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        duration: duration));
  }
}

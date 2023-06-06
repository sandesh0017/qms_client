// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qms_client/core/constants/colors.dart';
import 'package:qms_client/core/local/storage.dart';
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
  // SessionPreferences sessionPreferences = SessionPreferences();
  bool receiveNewToken = true;

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  PrinterHelper printerHelper = PrinterHelper();

  @override
  void initState() {
    super.initState();
    getSession().then((value) {
      return getServiceOffered(kioskIdLocal!);
    });
    getPrinterDetails();
  }

  Future<void> getSession() async {
    // var session = await sessionPreferences.getSession();
    // serviceCentreIdCodeLocal = session!.serviceCentreCode;
    // serviceCentreLocal = session.serviceCentreName;
    // kioskIdLocal = int.parse(session.koiskIdCode!);
    var session = await HiveHelper().getSessionHive();
    serviceCentreIdCodeLocal = session!.serviceCentreCode;
    serviceCentreLocal = session.serviceCentreName;
    kioskIdLocal = int.parse(session.koiskIdCode!);
  }

  Future<void> getPrinterDetails() async {
    printerHelper.scan();
    // var printerDetail = await sessionPreferences.getPrinterDetails();
    var printerDetail = HiveHelper().getPrinterHive();
    if (printerDetail == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const PosPrinterScreen()));
      });
    } else {
      // showCustomSnackBar(context, "Printer Connected", taskSuccess: true);
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
          height: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/logo2.png',
              scale: 1,
            ),
          ),
        ),
        centerTitle: true,
        title: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
                text: 'गण्डकी सरकार\n',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
                children: [
                  TextSpan(
                    text:
                        'भौतिक पूर्वाधार विकास तथा यातायात व्यवस्था मन्त्रालय\n',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: 'यातायात व्यवस्था कार्यालय सवारी चालक अनुमतिपत्र\n',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: 'कास्की\nगण्डकी प्रदेश, नेपाल',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ])),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/logo1.png',
              scale: 1,
            ),
          ),
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
                                                  'No Printer Connected! - //${printerHelper.selectedPrinter}//',
                                                  taskSuccess: false);
                                            }
                                          }
                                        : () {},
                                  );
                                },
                              )
                            : const Center(child: CircularProgressIndicator()),
                      ),
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
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  logOutOnPress(context);
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
}

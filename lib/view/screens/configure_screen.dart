// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qms_client/core/constants/colors.dart';
import 'package:qms_client/core/local/storage.dart';
import 'package:qms_client/core/utils/show_custom_snack_bar.dart';
import 'package:qms_client/view/screens/service_offered_screen.dart';

import '../../core/utils/show_ip_address_input_dialog.dart';
import '../../models/data_model_model.dart';
import '../../services/configure_services.dart';
import '../widgets/custom_button.dart';

class ConfigureScreen extends StatefulWidget {
  const ConfigureScreen({super.key});

  @override
  State<ConfigureScreen> createState() => _ConfigureScreenState();
}

class _ConfigureScreenState extends State<ConfigureScreen> {
  TextEditingController codeController = TextEditingController();

  List<DataModel>? serviceCentreList = [];
  List<DataModel>? kioskList = [];

  ConfigureServices configureServices = ConfigureServices();
  final formGlobalKey = GlobalKey<FormState>();

  int? selectedClientCode;
  int selectedServiceCentreCode = 0;
  int serviceCentreId = 0;
  String? selectedServiceCentre;
  int selectedKoiskId = 0;
  String errorMessage = '';
  bool isClientValidate = false;

  void loginOperation(BuildContext context) {
    if (selectedClientCode == null) {
      showCustomSnackBar(context, 'Please Enter Client Code');
    } else if (selectedServiceCentre == null) {
      showCustomSnackBar(context, 'Please Enter Service Centre');
    } else if (selectedKoiskId == 0) {
      showCustomSnackBar(context, 'Please Enter Koisk Device');
    } else {
      // SessionPreferences().setSession(
      //     userSession: UserSession(
      //         clientCode: selectedClientCode.toString(),
      //         koiskIdCode: selectedKoiskId.toString(),
      //         serviceCentreCode: selectedServiceCentreCode,
      //         serviceCentreName: selectedServiceCentre.toString()));
      HiveHelper().setSession(
          clientCode: selectedClientCode.toString(),
          koiskIdCode: selectedKoiskId.toString(),
          serviceCentreCode: selectedServiceCentreCode,
          serviceCentreName: selectedServiceCentre.toString());

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ServiceOfferedScreen()));
    }
  }

  Future<void> getKioskList(int serviceCentreId) async {
    try {
      var result = await ConfigureServices().getKioskList(serviceCentreId);

      if (result.data != null) {
        setState(() {
          selectedKoiskId = 0;
          kioskList = result.data ?? [];
        });
      } else {
        setState(() {
          errorMessage = result.message!;

          showCustomSnackBar(context, 'Error koisk device');
        });
      }
    } catch (e) {
      showCustomSnackBar(context, e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> getServiceCentreList(int clientId) async {
    try {
      var result = await configureServices.getServiceCentreList(clientId);

      if (result.data != null) {
        setState(() {
          serviceCentreList = result.data ?? [];
          selectedKoiskId = 0;
          kioskList!.clear();
          // log('serviceCentre${serviceCentreList![0].name}');
        });
      } else {
        setState(() {
          errorMessage = result.message!;
          showCustomSnackBar(context, 'Invalid Client Code');
        });
      }
    } catch (e) {
      showCustomSnackBar(context, e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<int> verifyClientCode(String clientCode) async {
    try {
      var result = await configureServices.getClientId(clientCode);
      if (result.status == 0) {
        setState(() {
          selectedClientCode = result.data!;
          selectedServiceCentreCode = 0;
          serviceCentreList!.clear();
          selectedKoiskId = 0;
          kioskList!.clear();
          isClientValidate = true;
        });
        return result.status!;
      } else {
        showCustomSnackBar(context, 'Invalid Client Code');
        return 1;
      }
    } catch (e) {
      showCustomSnackBar(context, e.toString().replaceAll('Exception: ', ''));
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/images/bc3.jpg',
              ),
              fit: BoxFit.fill),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: size.width * 0.32,
            constraints: const BoxConstraints(minWidth: 400),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 25, spreadRadius: 10)
              ],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        showIpAddressInputDialog(context);
                      },
                      child: const Text(
                        'Configure',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w100),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      child: Form(
                        autovalidateMode: AutovalidateMode.disabled,
                        key: formGlobalKey,
                        child: TextFormField(
                          controller: codeController,
                          validator: (val) {
                            return errorMessage;
                          },
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                isClientValidate ? Icons.done : Icons.close,
                                color: Colors.black,
                              ),
                              filled: true,
                              fillColor: Colors.blueGrey.shade100,
                              border: const OutlineInputBorder(),
                              labelText: 'Client Code',
                              labelStyle: TextStyle(color: AppColor.textColor),
                              hintText: 'Please enter a Client code',
                              prefixIcon: Icon(
                                Icons.abc,
                                color: AppColor.textColor,
                                size: 32,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColor.textColor),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueGrey[50]!),
                                borderRadius: BorderRadius.circular(25),
                              )),
                          cursorColor: Colors.black,
                          onFieldSubmitted: (val) {
                            verifyClientCode(val).then((value) {
                              if (value == 0) {
                                getServiceCentreList(selectedClientCode!);
                              } else {}
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      child: CustomDropDown(
                        key: UniqueKey(),
                        selectedId: selectedServiceCentreCode.toString(),
                        dataList: serviceCentreList!,
                        labelText: 'Select a Service Centre',
                        onChange: (val) async {
                          if (val != null) {
                            setState(() {
                              selectedServiceCentreCode = int.parse(val);
                              selectedServiceCentre =
                                  getServiceCenterName(int.parse(val))!;
                            });
                          }
                          getKioskList(int.parse(val!));
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      child: CustomDropDown(
                        key: UniqueKey(),
                        selectedId: selectedKoiskId.toString(),
                        dataList: kioskList!,
                        labelText: 'Select Kiosk Device',
                        onChange: (val) {
                          if (val != null) {
                            setState(() {
                              selectedKoiskId = int.parse(val);
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    LoginButton(
                      onPressed: () {
                        loginOperation(context);
                      },
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

  String? getServiceCenterName(int serviceCenterId) {
    for (int i = 0; i < serviceCentreList!.length; i++) {
      if (serviceCenterId == serviceCentreList![i].id) {
        return serviceCentreList![i].name;
      } else {
        continue;
      }
    }
    return null;
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qms_client/core/constants/colors.dart';
import 'package:qms_client/core/local/shared_prefence.dart';
import 'package:qms_client/core/utils/show_custom_snack_bar.dart';
import 'package:qms_client/models/user_session_model.dart';
import 'package:qms_client/view/screens/service_offered_screen.dart';

import '../../core/constants/api_endpoints.dart';
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
      SessionPreferences().setSession(
          userSession: UserSession(
              clientCode: selectedClientCode.toString(),
              koiskIdCode: selectedKoiskId.toString(),
              serviceCentreCode: selectedServiceCentreCode,
              serviceCentreName: selectedServiceCentre.toString()));

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

  TextEditingController ipAddressController =
      TextEditingController(text: ApiUrl.baseUrl);

  String? validateIpAddress() {
    String? value = ipAddressController.text;
    if (value.isEmpty) {
      return 'Enter new IP address!';
    }
    if (!value.startsWith(RegExp(r'https?://'))) {
      return 'Invalid IP address! Should start with "http://" or "https://"';
    }
    if (value.length < 9) {
      return 'Length of new IP address is invalid!';
    }
    return null;
  }

  void showIpAddressInputDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade200,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            title: const Text('Enter New IP Address',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                )),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                String? validationMessage = validateIpAddress();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_rounded,
                            size: 40, color: Colors.red),
                        const SizedBox(width: 15),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.9,
                          child: const Text(
                              'Data cannot be fetched from an invalid IP address! Make sure to enter a valid IP address.',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black87,
                                fontSize: 12,
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      child: TextFormField(
                        autofocus: true,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                        cursorColor: Colors.orange,
                        decoration: InputDecoration(
                          focusColor: Colors.orange,
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 3,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: Colors.red[300]!,
                                width: 3,
                              )),
                          contentPadding: const EdgeInsets.only(
                              bottom: 10, left: 20, right: 20),
                          hintText: 'New IP Address',
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                        ),
                        controller: ipAddressController,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (validationMessage != null)
                      Text(
                        validationMessage,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('CANCEL'),
                          ),
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                if (validationMessage == null) {
                                  ApiUrl.setNewBaseUrl(
                                      ipAddressController.text.trim());
                                  showCustomSnackBar(
                                    context,
                                    'IP Address changed successfully!',
                                  );
                                  Navigator.pop(context);
                                } else {
                                  showCustomSnackBar(context, validationMessage,
                                      taskSuccess: false);
                                }
                              });
                            },
                            child: const Text('CONFIRM'),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          );
        });
  }
}

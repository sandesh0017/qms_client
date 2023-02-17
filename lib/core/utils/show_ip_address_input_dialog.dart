import 'package:flutter/material.dart';
import 'package:qms_client/core/utils/show_custom_snack_bar.dart';

import '../constants/api_endpoints.dart';

TextEditingController ipAddressController = TextEditingController();

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
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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

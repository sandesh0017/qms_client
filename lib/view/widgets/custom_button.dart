import 'package:flutter/material.dart';

import 'package:qms_client/core/constants/colors.dart';
import 'package:qms_client/models/data_model_model.dart';

class LoginButton extends StatelessWidget {
  final void Function()? onPressed;

  const LoginButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 2,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const SizedBox(
            height: 50,
            child: Center(
                child: Text(
              "Save ",
              style: TextStyle(fontSize: 18),
            ))),
      ),
    );
  }
}

class CustomDropDown extends StatelessWidget {
  List<DataModel> dataList;
  String labelText;
  String selectedId;
  void Function(String?) onChange;

  CustomDropDown({
    Key? key,
    required this.dataList,
    required this.selectedId,
    required this.labelText,
    required this.onChange,
  }) : super(key: key);

  String selectedValue = 'N/A';

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> listItems = [
      DropdownMenuItem<String>(value: "0", child: Text(labelText))
    ];

    return DropdownButtonFormField<String>(
      key: UniqueKey(),
      borderRadius: BorderRadius.circular(25),
      value: selectedId,
      elevation: 50,
      items: dataList.isNotEmpty
          ? [
              ...listItems,
              ...dataList
                  .map((e) => DropdownMenuItem<String>(
                        value: e.id.toString(),
                        // value: e.id.toString(),
                        child: Text(e.name.toString()),
                      ))
                  .toList()
            ]
          : listItems
      // .map((e) => DropdownMenuItem<String>(
      //       value: e.id.toString(),
      //       child: Text(
      //         e.name,
      //       ),
      //     ),
      //     )
      // .toList()
      ,
      onChanged: onChange,

      // onChanged: (val) {
      //   onChange(val);
      // },
      icon: Icon(
        Icons.arrow_drop_down_circle,
        color: AppColor.textColor,
      ),
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.textColor),
            borderRadius: BorderRadius.circular(25),
          ),
          labelText: labelText,
          labelStyle: TextStyle(color: AppColor.textColor),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.textColor),
              borderRadius: BorderRadius.circular(25)),
          prefixIcon: Icon(
            Icons.apartment_outlined,
            color: AppColor.textColor,
            size: 32,
          )),
    );
  }
}

class CustomElevatedButton extends StatefulWidget {
  DataModel serviceOfferedList;
  void Function()? onPressed;

  CustomElevatedButton({
    Key? key,
    required this.serviceOfferedList,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double buttonHeight = size.height * 0.15;
    double buttonWidth = size.width * 0.2;
    return Container(
      height: buttonHeight,
      width: buttonWidth,
      margin: const EdgeInsets.only(top: 25),
      child: Center(
        child: ElevatedButton(
          style: ButtonStyle(
              animationDuration: const Duration(seconds: 1),
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return AppColor.primaryColor.withOpacity(0.6);
                }
                return AppColor.primaryColor;
              }),
              fixedSize: MaterialStateProperty.resolveWith(
                (states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Size(buttonWidth * 0.8, buttonHeight * 0.8);
                  }
                  return Size(buttonWidth, buttonHeight);
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.red)))),
          onPressed: widget.onPressed,
          child: Text(
            widget.serviceOfferedList.name,
            style: const TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      ),
    );
  }
}

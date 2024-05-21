import 'package:flutter/material.dart';

class FormDropDown extends StatelessWidget {
  final String selectedValue;
  final List<String> itemList;
  final Function(String) onChange;
  final labletext;

  const FormDropDown({
    Key? key,
    required this.selectedValue,
    required this.itemList,
    required this.onChange,
    this.labletext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("rebuild dropdown");
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            labletext,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Container(
            // height: Get.height / 16,
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black26),
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              dropdownColor: Colors.white,
              underline: Container(),
              isExpanded: true,
              borderRadius: BorderRadius.circular(5),
              value: selectedValue,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChange(newValue);
                }
              },
              items: itemList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

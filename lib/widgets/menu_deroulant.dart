import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';

class MenuDeroulant extends StatefulWidget {
  final String indication;
  final List<String> items;
  final double? width;
  final String? selectedValue;
  final Function(String?)? onChanged;
  final Function(String?)? onChanged2;
  final double? height;
  String? initValue;
  MenuDeroulant({Key? key,String? value, required this.indication, required this.items,@required this.onChanged2,
    @required this.width,@required this.selectedValue,@required this.height,@required this.onChanged,@required this.initValue}) : super(key: key);

  @override
  State<MenuDeroulant> createState() => _MenuDeroulantState();
}

class _MenuDeroulantState extends State<MenuDeroulant> {

  String? selectedValue;

  @override
  void initState() {
    selectedValue = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropdownButton2(
      hint: widget.indication,
      dropdownElevation: 2,
      dropdownWidth: 200,
      buttonWidth: widget.width ?? 200,
      dropdownItems: widget.items,
      buttonHeight: widget.height?? widget.height,
      icon: Icon(Icons.keyboard_arrow_down_outlined),
      scrollbarAlwaysShow: true,
      value: widget.selectedValue ?? selectedValue,
      onChanged: widget.onChanged2 ?? (value) {
        setState(() {
          selectedValue = value;
        });
        widget.onChanged!(selectedValue);
      },
    );
  }
}

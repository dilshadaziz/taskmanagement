import 'package:flutter/material.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const MyInputField(
      {required this.title,
      required this.hint,
      this.controller,
      this.widget,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 52,
            decoration: BoxDecoration(
                border: widget == null ? null : Border.all(width: 1.0),
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Expanded(
                  child:TextFormField(readOnly: widget !=null ? true : false,
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              focusedBorder: widget !=null? null : OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black,width: 1.5),
                  borderRadius: BorderRadius.circular(10)),
              border: widget != null? OutlineInputBorder(borderSide: BorderSide.none) : OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          )
                ),
                widget == null ? Container() : Container(child: widget,)
              ],
            ),
          )
        ],
      ),
    );
  }
}

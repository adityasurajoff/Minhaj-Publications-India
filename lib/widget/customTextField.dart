import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final IconData prefixIcon;
  final TextInputType inputType;
  final int maxLines;
  final bool isobsecure;
  final int maxlength;
  CustomTextField({
    this.label,
    this.controller,
    this.prefixIcon,
    this.inputType,
    this.maxLines,
    this.isobsecure,
    this.maxlength,
  });
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObsecure = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      width: size.width - 50,
      child: TextField(
        cursorColor: Colors.white,
        controller: widget.controller,
        maxLength: widget.maxlength == null ? null : widget.maxlength,
        keyboardType:
            widget.inputType == null ? TextInputType.text : widget.inputType,
        maxLines: widget.maxLines == null ? 1 : widget.maxLines,
        obscureText: widget.isobsecure == null ? false : _isObsecure,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          counterStyle: TextStyle(color: Colors.white),
          suffixIcon: widget.label == "Password"
              ? IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObsecure = !_isObsecure;
                    });
                  },
                )
              : SizedBox.shrink(),
          prefixIcon: Icon(
            widget.prefixIcon == null
                ? Icons.local_hospital
                : widget.prefixIcon,
            color: Colors.white,
          ),
          labelText: widget.label == null ? "Email ID" : widget.label,
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }
}

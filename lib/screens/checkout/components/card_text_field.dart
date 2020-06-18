import 'package:flutter/material.dart';

class CardTextField extends StatelessWidget {

  CardTextField({this.title, this.bold = false, this.hint, this.textInputType});

  final String title;
  final bool bold;
  final String hint;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.white
            ),
          ),
          TextFormField(
            style: TextStyle(
              color: Colors.white,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withAlpha(100)
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 2)
            ),
            keyboardType: textInputType,
          ),
        ],
      ),
    );
  }
}

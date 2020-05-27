import 'package:flutter/material.dart';
import 'package:lojavirtual/models/section.dart';

class SectionHeader extends StatelessWidget {

  const SectionHeader(this.section);

  final Section section;

  @override
  Widget build(BuildContext context) {
    return Text(
      section.name,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 18,
      ),
    );
  }
}

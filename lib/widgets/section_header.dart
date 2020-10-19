import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, top: 32.0, right: 16.0, bottom: 8.0),
      child: Text(
        '$label',
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}

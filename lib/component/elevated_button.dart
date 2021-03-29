import 'package:flutter/material.dart';

import '../provider_page2.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String label;
  final Function onPressed;

  ElevatedButtonWidget({this.label, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: onPressed,
    );
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaddingWidget extends StatelessWidget {
  final String label;
  final Function onChanged;

  const PaddingWidget({Key key, this.label,@required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
             padding: const EdgeInsets.all(8.0),
             child: TextFormField(
               decoration: InputDecoration(
                 labelText: label,
                 fillColor: Colors.white,
                 focusedBorder: OutlineInputBorder(
                   borderSide: BorderSide(
                     color: Colors.blue,
                     width: 2.0,
                   ),
                 ),
               ),
               onChanged: onChanged,
             ),
           );
  }
}
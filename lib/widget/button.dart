import 'package:flutter/material.dart';

class RiderButtons extends StatelessWidget {
  final String title;
  final Function onTap;
  final Color color;
  final bool isDisabled;

  const RiderButtons({
    Key key,
    @required this.title,
    @required this.onTap,
    this.isDisabled = false,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
          borderRadius: BorderRadius.circular(6),
      ),
      child: FlatButton(
        onPressed: () {
          if (!isDisabled) {
            onTap();
          }
        },
        child:Text(
          title,
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
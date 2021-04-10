import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key key, 
    @required this.text, 
    @required this.onPressed
  }) : super(key: key);

  final String text;
  final Function onPressed;
  

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric( vertical: 15.0),
        child: Center(child: Text(this.text)),
      ),
      style: ElevatedButton.styleFrom(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        primary: Colors.blue, // background
        onPrimary: Colors.white, // foreground
      ),
      onPressed: this.onPressed,
    );
  }
}
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key key, @required this.titulo}) : super(key: key);

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170.0,
        margin: EdgeInsets.only(top: 50.0),
        child: SafeArea(
          child: Column(
            children: [
              Image(image: AssetImage('assets/logo-empresa.png')),
              Text(this.titulo, style: TextStyle(fontSize: 30),)
            ],
          ),
        ),
      ),
    );
  }

}
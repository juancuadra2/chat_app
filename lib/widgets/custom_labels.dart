import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  const Labels({Key key, @required this.ruta, @required this.labelRoute, @required this.labelCuenta}) : super(key: key);

  final String ruta;
  final String labelRoute;
  final String labelCuenta;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [

          Text(this.labelCuenta, style: TextStyle(
            color: Colors.black54,
            fontSize: 15,
            fontWeight: FontWeight.w300
          )),

          SizedBox( height: 10 ),

          GestureDetector(
            onTap: (){
              Navigator.pushReplacementNamed(context, ruta);
            },
            child: Text(this.labelRoute, style: TextStyle(
              color: Colors.blue[600],
              fontSize: 18,
              fontWeight: FontWeight.bold
            )),
          ),

        ],
      ),
    );
  }

}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void mostrarAlerta(BuildContext context, String titulo, String contenido) {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context, 
      builder: (_) => CupertinoAlertDialog(
        title: Text(titulo),
        content: Text(contenido),
        actions: [
          CupertinoDialogAction(
            child: Text('OK'),
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
          )
        ],
      )
    );
  }
  showDialog(
    context: context, 
    builder: (_) => AlertDialog(
      title: Text(titulo),
      content: Text(contenido),
      actions: [
        MaterialButton(
          child: Text('Ok'),
          elevation: 1,
          textColor: Colors.blue,
          onPressed: ()=> Navigator.pop(context)
        )
      ],
    )
  );
}
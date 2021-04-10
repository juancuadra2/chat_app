import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/usuarios_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async{
    final service = Provider.of<AuthService>(context, listen: false);
    final autenticado = await service.isLoggedIn();
    if (autenticado) {
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => UsuarioPage(),
        transitionDuration: Duration(milliseconds: 0)
      ));
    }else{
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => LoginPage(),
        transitionDuration: Duration(milliseconds: 0)
      ));
    }
  } 

}
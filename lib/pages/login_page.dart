import 'package:chat_app/widgets/custom_boton.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/custom_labels.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Logo( titulo: 'Login',),
              Form(),
              Labels(
                labelCuenta: '¿No tienes cuenta?',
                labelRoute: 'Crear una ahora',
                ruta: 'register',
              ),
              Text('Términos y condiciones de uso', style: TextStyle(
                fontWeight: FontWeight.w300
              )),
            ],
          ),
        ),
      ),
    );
  }
}



class Form extends StatefulWidget {
  Form({Key key}) : super(key: key);

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<Form> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric( horizontal: 50 ),
      child: Column(
        children: [

          CustomInput(
            icon: Icons.email_outlined,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailController,
          ),

          CustomInput(
            icon: Icons.vpn_key,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: passwordController,
            isPassword: true,
          ),

          CustomButton(
            text: 'Ingresar',
            onPressed: (){},
          ),

        ],
       ),
    );
  }
}


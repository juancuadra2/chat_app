import 'package:chat_app/helpers/mostrar_dialog.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/custom_boton.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/custom_labels.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key key}) : super(key: key);

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
              Logo( titulo: 'Registro',),
              Form(),
              Labels(
                labelCuenta: '¿Ya tienes cuenta?',
                labelRoute: 'Ir al login',
                ruta: 'login',
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

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<AuthService>(context);
    final SocketService socketService = Provider.of<SocketService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric( horizontal: 50 ),
      child: Column(
        children: [

          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameController,
          ),

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
            text: 'Registrarse',
            onPressed: service.loading ? null : ()async{
              FocusScope.of(context).unfocus();
              final res = await service.register(nameController.text, emailController.text, passwordController.text);
              if (res == true) {
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'usuarios');
              }else{
                mostrarAlerta(context, "Error al registrarse", res);
              }
            },
          ),

        ],
       ),
    );
  }
}
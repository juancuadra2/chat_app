import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/mensaje.dart';
import 'package:chat_app/models/mensajes_response.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class ChatService with ChangeNotifier {
  
  Usuario usuarioTo;

  Future<List<Mensaje>> getChats(String userUid) async{
    try {
      final token = await AuthService.getToken();
      final res = await http.get( Uri.parse('${ Enviroment.apiUrl }/mensajes/$userUid'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token
        }
      );
      final mensajes = mensajesResponseFromJson(res.body);
      return mensajes.mensajes;
    } catch (e) {
      return [];
    }
  }
  
}
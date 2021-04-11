import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/usuarios_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/models/usuario.dart';

class UsuarioService {
  
  Future<List<Usuario>> getUsuarios() async{
    try {
      final token = await AuthService.getToken();
      final res = await http.get( Uri.parse('${ Enviroment.apiUrl }/usuarios'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token
        }
      );
      final usuarios = usuariosResponseFromJson(res.body);
      return usuarios.usuarios;
    } catch (e) {
      return [];
    }
  }

}
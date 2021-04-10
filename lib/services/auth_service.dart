import 'dart:convert';

import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {

  Usuario usuario;
  bool _loading = false;
  // Create storage
  final _storage = new FlutterSecureStorage();

  get loading => this._loading;
  set loading(bool valor){
    this._loading = valor;
    notifyListeners();
  }

  //Getters  token
  static Future<String> getToken() async{
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async{
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }
  
  Future<bool> login(String email, String password) async{
    this.loading = true;
    final data = {
      "email": email,
      "password": password
    };
    final res = await http.post(
      Uri.parse('${ Enviroment.apiUrl }/login'),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );
    this.loading = false;
    print(res.body); 
    if (res.statusCode == 200) { 
      final response = loginResponseFromJson(res.body);
      this.usuario = response.usuario;
      await this._guardarToken(response.token);
      return true;
    }   
    return false;
  }

  Future register(String nombre, String email, String password) async{
    loading = true;
    final data = {
      "nombre": nombre,
      "email": email,
      "password": password
    };
    final res = await http.post(
      Uri.parse('${ Enviroment.apiUrl }/login/new'),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );
    loading = false;
    print(res.body);
    if (res.statusCode == 200) { 
      final response = loginResponseFromJson(res.body);
      this.usuario = response.usuario;
      await this._guardarToken(response.token);
      return true;
    }else{
      final resJson = jsonDecode(res.body);
      return resJson['msg'];
    } 
    
  }

  Future<bool> isLoggedIn() async{
    final token = await this._storage.read(key: 'token');
    print(token);
    final res = await http.get(
      Uri.parse('${ Enviroment.apiUrl }/login/renovarJTW'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token
      }
    );
    print(res.body);
    if (res.statusCode == 200) { 
      final response = loginResponseFromJson(res.body);
      this.usuario = response.usuario;
      await this._guardarToken(response.token);
      return true;
    }else{
      this.logout();
      return false;
    }
  }

  Future _guardarToken(String token) async{
    await _storage.write(key: 'token', value: token);
    return;
  }

  Future logout() async{
    await _storage.delete(key: 'token');
  }

}
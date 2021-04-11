import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {
  
  //Atributos
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  //Getters
  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  void connect() async{

    final token = await AuthService.getToken();

    this._socket= IO.io(Enviroment.socketUrl, 
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableForceNew()
        .setExtraHeaders({
          'x-token': token
        })
        .build());

    this._socket.onConnect((_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onDisconnect((_){
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // this._socket.on('active-bands', (data) {
    //   print(data);
    // });

  }

  void disconnect() {
    this._socket.disconnect();
  }

}
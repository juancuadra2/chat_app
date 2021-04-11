import 'dart:io';

import 'package:chat_app/models/mensaje.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  bool _escribiendo = false;
  List<Message> _mensajes = [];

  @override
  void initState() {
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(this.chatService.usuarioTo.uid);
    super.initState();
  }

  void _escucharMensaje(dynamic data) {
    print('Tengo mensaje $data');
    Message mensaje = new Message(
      texto: data['mensaje'],
      uid: data['from']
    );
    setState(() {
      _mensajes.insert(0, mensaje);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    Usuario usuario = chatService.usuarioTo;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 5.0,
        leadingWidth: 30,
        leading: BackButton(color: Colors.black87),
        title: Row(
          children: [
            CircleAvatar(
              child: Text(usuario.nombre.substring(0, 2)),
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(width: 5),
            Text(
              usuario.nombre,
              style: TextStyle(color: Colors.black87),
            )
          ],
        ),
        elevation: 0.5,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _mensajes.length,
              itemBuilder: (_, i) => _mensajes[i],
              reverse: true,
            )),
            Divider(height: 1),
            Container(
              color: Colors.white,
              child: _inputChat(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
              child: TextField(
            controller: _textController,
            onSubmitted: _handleSubmit,
            onChanged: (String texto) {
              setState(() {
                _escribiendo = texto.trim().length > 0;
              });
            },
            decoration: InputDecoration(
              hintText: 'Escribir mensaje',
            ),
            focusNode: _focusNode,
          )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: Platform.isIOS ? CupertinoButton(
              child: Text('Enviar'),
              onPressed: !_escribiendo ? null : () => _handleSubmit(_textController.text)
            ) : Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconTheme(
                key: UniqueKey(),
                data: IconThemeData(color: Colors.blue[400]),
                child: IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: Icon(Icons.send),
                  onPressed: !_escribiendo ? null : () => _handleSubmit(_textController.text),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }

  _handleSubmit(String text) {
    _textController.clear();
    _focusNode.requestFocus();
    
    this._mensajes.insert(0, new Message(uid: authService.usuario.uid, texto: text));

    setState(() {
      _escribiendo = false;
    });

    this.socketService.socket.emit('mensaje-personal', {
      'from': this.authService.usuario.uid,
      'to': this.chatService.usuarioTo.uid,
      'mensaje': text
    });
  }

  void _cargarHistorial(String uid) async{
    List<Mensaje> mensajes = await this.chatService.getChats(uid);
    final historial = mensajes.map((e) => new Message(
      texto: e.mensaje,
      uid: e.from,
    ));
    setState(() {
      this._mensajes.insertAll(0, historial);
    });
    
  }

  @override
  void dispose() {
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }

  
}

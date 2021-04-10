import 'dart:io';

import 'package:chat_app/widgets/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _escribiendo = false;
  List<Message> _mensajes = [
    Message(uid: '123', texto: 'Hola'),
    Message(uid: '1231', texto: 'Hola'),
    Message(uid: '123', texto: 'Como estas?'),
    Message(uid: '1231', texto: 'Bien'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          children: [
            CircleAvatar(
              child: Text('Jd', style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 16,
            ),
            SizedBox(height: 3),
            Text('Juan David', style: TextStyle(color: Colors.black87, fontSize: 12),)
          ],
        ),
        elevation: 1,
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
              )
            ),

            Divider( height: 1 ),

            Container(
              color: Colors.white,
              child: _inputChat(),
            ),

          ],
        ),
      ),
    );
  }

  Widget _inputChat(){
    return SafeArea(child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [

          Flexible(child: TextField(
            controller: _textController,
            onSubmitted: _handleSubmit,
            onChanged: (String texto){
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

  _handleSubmit(String text){
    print(text);

    this._mensajes.insert(0, new Message(uid: '123', texto: text));

    setState(() {
      _escribiendo = false;
    });
    _textController.clear();
    _focusNode.requestFocus();
  }
}
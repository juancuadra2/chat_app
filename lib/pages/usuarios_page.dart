import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuarioPage extends StatefulWidget {
  const UsuarioPage({Key key}) : super(key: key);

  @override
  _UsuarioPageState createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  final UsuarioService usuarioService = new UsuarioService();
  List<Usuario> usuarios = [];

  @override
  void initState() {
    this._cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<AuthService>(context);
    final SocketService socketService = Provider.of<SocketService>(context);
    Usuario usuario = service.usuario;
    return Scaffold(
      appBar: AppBar(
        title: Text(usuario.nombre, style: TextStyle(color: Colors.black54)),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black54),
          onPressed: (){
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only( right: 10 ),
            child: socketService.serverStatus == ServerStatus.Online ? 
            Icon(Icons.check_circle, color: Colors.green[400]) : 
            Icon(Icons.offline_bolt, color: Colors.red[400]),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        child: _listViewUsuarios(),
        onRefresh: _cargarUsuarios,
      )
      
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioTile(usuarios[i]),
      separatorBuilder: (_, i) => Divider(),
      itemCount: usuarios.length,
    );
  }

  Widget _usuarioTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      leading: CircleAvatar(
        child:  Text(usuario.nombre.substring(0,2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100)
        ),
      ),
      onTap: (){
        final ChatService chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioTo = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _cargarUsuarios() async{
    this.usuarios = await usuarioService.getUsuarios();
    setState(() {});
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

}
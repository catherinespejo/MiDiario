import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../vm/usuario_vm.dart';

class UsuarioPage extends StatefulWidget {
  @override
  _UsuarioPageState createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  final _formKey = GlobalKey<FormState>();
  Usuario _currentUsuario = Usuario();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UsuarioViewModel>(context, listen: false).fetchUsuarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioVM = Provider.of<UsuarioViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
      ),
      body: Column(
        children: [
          _buildForm(usuarioVM),
          Expanded(
            child: _buildUsuarioList(usuarioVM),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(UsuarioViewModel usuarioVM) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              initialValue: _currentUsuario.nombre,
              onChanged: (value) => setState(() => _currentUsuario.nombre = value),
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              initialValue: _currentUsuario.email,
              onChanged: (value) => setState(() => _currentUsuario.email = value),
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              initialValue: _currentUsuario.password,
              onChanged: (value) => setState(() => _currentUsuario.password = value),
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            // Agrega más campos si es necesario
            ElevatedButton(
              onPressed: () async {
                if (_isUpdating) {
                  await usuarioVM.updateUsuario(_currentUsuario.id!, _currentUsuario);
                  setState(() {
                    _isUpdating = false;
                    _resetForm();
                  });
                } else {
                  await usuarioVM.addUsuario(_currentUsuario);
                  _resetForm();
                }
                usuarioVM.fetchUsuarios();
              },
              child: Text(_isUpdating ? 'Actualizar' : 'Añadir'),
            ),
          ],
        ),
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _formKey.currentState?.reset();
      _currentUsuario = Usuario();
    });
  }

  Widget _buildUsuarioList(UsuarioViewModel usuarioVM) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: usuarioVM.usuarios.length,
      itemBuilder: (context, index) {
        final usuario = usuarioVM.usuarios[index];
        return ListTile(
          title: Text(usuario.nombre ?? 'Sin nombre'),
          subtitle: Text(usuario.email ?? 'Sin email'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _currentUsuario = usuario;
                    _isUpdating = true;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await usuarioVM.deleteUsuario(usuario.id!);
                  usuarioVM.fetchUsuarios();
                  if (_isUpdating) {
                    _resetForm();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

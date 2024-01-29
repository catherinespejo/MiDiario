
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../vm/entrada_diario._vm.dart';

class EntradaDiarioPage extends StatefulWidget {
  @override
  _EntradaDiarioPageState createState() => _EntradaDiarioPageState();
}

class _EntradaDiarioPageState extends State<EntradaDiarioPage> {
  final _formKey = GlobalKey<FormState>();
  EntradaDiario _currentEntrada = EntradaDiario();
  bool _isUpdating = false;

  @override
  Widget build(BuildContext context) {
    final entradaDiarioVM = Provider.of<EntradaDiarioViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Entradas de Diario'),
      ),
      body: Column(
        children: [
          _buildForm(entradaDiarioVM),
          Expanded(
            child: _buildEntradaDiarioList(entradaDiarioVM),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(EntradaDiarioViewModel entradaDiarioVM) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            initialValue: _currentEntrada.titulo,
            onChanged: (value) => setState(() => _currentEntrada.titulo = value),
            decoration: const InputDecoration(labelText: 'Título'),
          ),
          TextFormField(
            initialValue: _currentEntrada.contenido,
            onChanged: (value) => setState(() => _currentEntrada.contenido = value),
            decoration: const InputDecoration(labelText: 'Contenido'),
            maxLines: 3,
          ),
          ElevatedButton(
            onPressed: () async {
              if (_isUpdating) {
                await entradaDiarioVM.updateEntradaDiario(_currentEntrada.id!, _currentEntrada);
                setState(() => _isUpdating = false);
              }
              _resetForm();
              entradaDiarioVM.fetchEntradasDiario();
            },
            child: Text(_isUpdating ? 'Actualizar' : 'Añadir'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _formKey.currentState?.reset();
      _currentEntrada = EntradaDiario();
      _isUpdating = false;
    });
  }

  Widget _buildEntradaDiarioList(EntradaDiarioViewModel entradaDiarioVM) {
    return ListView.builder(
      itemCount: entradaDiarioVM.entradas.length,
      itemBuilder: (context, index) {
        final entrada = entradaDiarioVM.entradas[index];
        return ListTile(
          title: Text(entrada.titulo ?? 'Sin título'),
          subtitle: Text(entrada.fechaCreacion?.toIso8601String() ?? ''),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _currentEntrada = entrada;
                    _isUpdating = true;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

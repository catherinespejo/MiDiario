// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mi_diario/models/models.dart';
import 'package:mi_diario/vm/estado_animo_vm.dart';
import 'package:provider/provider.dart';

class EstadoAnimoPage extends StatefulWidget {
  const EstadoAnimoPage({super.key});

  @override
  _EstadoAnimoPageState createState() => _EstadoAnimoPageState();
}

class _EstadoAnimoPageState extends State<EstadoAnimoPage> {
  final _formKey = GlobalKey<FormState>();
  EstadoAnimo _currentEstadoAnimo = EstadoAnimo(estadoAnimo: '');
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EstadoAnimoViewModel>(context, listen: false)
          .fetchEstadosAnimo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final estadoAnimoVM = Provider.of<EstadoAnimoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Estados de Ánimo'),
      ),
      body: Column(
        children: [
          _buildForm(estadoAnimoVM),
          Expanded(
            child: _buildEstadoAnimoList(estadoAnimoVM),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(EstadoAnimoViewModel estadoAnimoVM) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            initialValue: _currentEstadoAnimo.estadoAnimo,
            onChanged: (value) =>
                setState(() => _currentEstadoAnimo.estadoAnimo = value),
            decoration: const InputDecoration(labelText: 'Estado de Ánimo'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_isUpdating) {
                await estadoAnimoVM.updateEstadoAnimo(
                    _currentEstadoAnimo.id!, _currentEstadoAnimo);
                setState(() => _isUpdating = false);
              } else {
                await estadoAnimoVM.addEstadoAnimo(_currentEstadoAnimo);
              }
              _resetForm();
              estadoAnimoVM.fetchEstadosAnimo();
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
      _currentEstadoAnimo = EstadoAnimo(estadoAnimo: '');
      _isUpdating = false;
    });
  }

  Widget _buildEstadoAnimoList(EstadoAnimoViewModel estadoAnimoVM) {
    return ListView.builder(
      itemCount: estadoAnimoVM.estadosAnimo.length,
      itemBuilder: (context, index) {
        final estado = estadoAnimoVM.estadosAnimo[index];
        return ListTile(
          title: Text(estado.estadoAnimo),
          subtitle: Text(estado.fecha?.toIso8601String() ?? ''),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _currentEstadoAnimo = estado;
                    _isUpdating = true;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await estadoAnimoVM.deleteEstadoAnimo(estado.id!);
                  estadoAnimoVM.fetchEstadosAnimo();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

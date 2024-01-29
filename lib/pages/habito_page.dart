import 'package:flutter/material.dart';
import 'package:mi_diario/models/models.dart';
import 'package:mi_diario/vm/habitos_vm.dart';
import 'package:provider/provider.dart';

class HabitoPage extends StatefulWidget {
  @override
  _HabitoPageState createState() => _HabitoPageState();
}

class _HabitoPageState extends State<HabitoPage> {
  final _formKey = GlobalKey<FormState>();
  Habito _currentHabito = Habito(completado: false, habito: '');
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HabitoViewModel>(context, listen: false).fetchHabitos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final habitoVM = Provider.of<HabitoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Hábitos'),
      ),
      body: Column(
        children: [
          _buildForm(habitoVM),
          Expanded(
            child: _buildHabitoList(habitoVM),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(HabitoViewModel habitoVM) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            initialValue: _currentHabito.habito,
            onChanged: (value) => setState(() => _currentHabito.habito = value),
            decoration: const InputDecoration(labelText: 'Hábito'),
          ),
          SwitchListTile(
            title: const Text('Completado'),
            value: _currentHabito.completado,
            onChanged: (bool value) {
              setState(() {
                _currentHabito.completado = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () async {
              if (_isUpdating) {
                await habitoVM.updateHabito(_currentHabito.id!, _currentHabito);
                setState(() => _isUpdating = false);
              } else {
                await habitoVM.addHabito(_currentHabito);
              }
              _resetForm();
              habitoVM.fetchHabitos();
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
      _currentHabito = Habito(completado: false, habito: '');
      _isUpdating = false;
    });
  }

  Widget _buildHabitoList(HabitoViewModel habitoVM) {
    return ListView.builder(
      itemCount: habitoVM.habitos.length,
      itemBuilder: (context, index) {
        final habito = habitoVM.habitos[index];
        return ListTile(
          title: Text(habito.habito ?? ''),
          subtitle: Text(habito.fecha?.toIso8601String() ?? ''),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _currentHabito = habito;
                    _isUpdating = true;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await habitoVM.deleteHabito(habito.id!);
                  habitoVM.fetchHabitos();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

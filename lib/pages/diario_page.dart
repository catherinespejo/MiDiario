import 'package:flutter/material.dart';
import 'package:mi_diario/vm/entrada_diario._vm.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../vm/estado_animo_vm.dart';
import '../vm/habitos_vm.dart';

class MiDiarioPage extends StatefulWidget {
  @override
  _MiDiarioPageState createState() => _MiDiarioPageState();
}

class _MiDiarioPageState extends State<MiDiarioPage> {
  String? _selectedEstadoAnimo;
  List<String> _selectedHabitos =
      []; // Lista para múltiples hábitos seleccionados
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _contenidoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EstadoAnimoViewModel>(context, listen: false)
          .fetchEstadosAnimo();
      Provider.of<HabitoViewModel>(context, listen: false).fetchHabitos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final estadoAnimoVM = Provider.of<EstadoAnimoViewModel>(context);
    final habitoVM = Provider.of<HabitoViewModel>(context);
    final entradaDiarioVM = Provider.of<EntradaDiarioViewModel>(context);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextFormField(
              controller: _contenidoController,
              decoration: const InputDecoration(labelText: '¿Qué hiciste hoy?'),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            const Text('¿Cómo te sentiste?'),
            Container(
              height: 50, // Altura fija para el contenedor de los chips
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: estadoAnimoVM.estadosAnimo.length,
                itemBuilder: (context, index) {
                  final estadoAnimo = estadoAnimoVM.estadosAnimo[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(estadoAnimo.estadoAnimo),
                      selected: _selectedEstadoAnimo == estadoAnimo.estadoAnimo,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedEstadoAnimo = estadoAnimo.estadoAnimo;
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text('¿Qué hábito completaste?'),
            Container(
              height: 50, // Altura fija para el contenedor de los chips
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: habitoVM.habitos.length,
                itemBuilder: (context, index) {
                  final habito = habitoVM.habitos[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(habito.habito),
                      selected: _selectedHabitos.contains(habito.habito),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected && !_selectedHabitos.contains(habito.habito)) {
                            _selectedHabitos.add(habito.habito);
                          } else if (!selected) {
                            _selectedHabitos.removeWhere((h) => h == habito.habito);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedEstadoAnimo != null && _selectedHabitos.isNotEmpty) {
                  entradaDiarioVM.addEntradaDiarioConDetalles(
                    EntradaDiario(
                      titulo: _tituloController.text,
                      contenido: _contenidoController.text,
                    ),
                    _selectedEstadoAnimo!,
                    _selectedHabitos,
                  );
                }
              },
              child: const Text('Insertar'),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildEstadoAnimoSection(EstadoAnimoViewModel estadoAnimoVM) {
    return Wrap(
      spacing: 8.0, 
      runSpacing: 8.0, 
      children: estadoAnimoVM.estadosAnimo.map((estadoAnimo) {
        return Padding(
          padding: const EdgeInsets.all(4.0), 
          child: ChoiceChip(
            label: Text(estadoAnimo.estadoAnimo),
            selected: _selectedEstadoAnimo == estadoAnimo.estadoAnimo,
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  _selectedEstadoAnimo = estadoAnimo.estadoAnimo;
                }
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHabitoSection(HabitoViewModel habitoVM) {
    return Wrap(
      spacing: 8.0, 
      runSpacing: 8.0, 
      children: habitoVM.habitos.map((habito) {
        return Padding(
          padding: const EdgeInsets.all(4.0), 
          child: ChoiceChip(
            label: Text(habito.habito),
            selected: _selectedHabitos.contains(habito.habito),
            onSelected: (bool selected) {
              setState(() {
                if (selected && !_selectedHabitos.contains(habito.habito)) {
                  _selectedHabitos.add(habito.habito);
                } else if (!selected) {
                  _selectedHabitos.removeWhere((h) => h == habito.habito);
                }
              });
            },
          ),
        );
      }).toList(),
    );
  }
}

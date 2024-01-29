import 'package:flutter/material.dart';
import 'package:mi_diario/pages/animus_page.dart';
import 'package:mi_diario/pages/diario_page.dart';
import 'package:mi_diario/pages/habito_page.dart';
import 'package:mi_diario/pages/usuarios_page.dart';

import 'entradas_d_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Principal'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildTopSection(context)),
          _buildGridButtonRow(
            button1: _buildGridButton(
              icon: Icons.emoji_emotions,
              color: Colors.blue,
              label: 'Estados de Animo',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EstadoAnimoPage(),
                  ),
                );
              },
            ),
            button2: _buildGridButton(
              icon: Icons.person,
              color: Colors.green,
              label: 'Usuarios',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsuarioPage(),
                  ),
                );
              },
            ),
          ),
          _buildGridButtonRow(
            button1: _buildGridButton(
              icon: Icons.task,
              color: Colors.orange,
              label: 'Hábitos',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HabitoPage()),
                );
              },
            ),
            button2: _buildGridButton(
              icon: Icons.book,
              color: Colors.purple,
              label: 'Entradas Diario',
              onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EntradaDiarioPage()),
            );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection(context) {
    return Container(
      color: Colors.red,
      child: MiDiarioPage(),
    );
  }

  Widget _buildGridButtonRow({
    required Widget button1,
    required Widget button2,
  }) {
    return Row(
      children: [
        Expanded(child: button1),
        Expanded(child: button2),
      ],
    );
  }

  Widget _buildGridButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Icon(icon, size: 25),
          ),
          Text(label),
        ],
      ),
    );
  }
}

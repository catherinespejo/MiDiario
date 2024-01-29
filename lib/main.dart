import 'package:flutter/material.dart';
import 'package:mi_diario/pages/home_page.dart';
import 'package:mi_diario/pages/login_page.dart';
import 'package:mi_diario/vm/entrada_diario._vm.dart';
import 'package:mi_diario/vm/habitos_vm.dart';
import 'package:mi_diario/vm/estado_animo_vm.dart';
import 'package:mi_diario/vm/usuario_vm.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HabitoViewModel()),
        ChangeNotifierProvider(create: (context) => EstadoAnimoViewModel()),
        ChangeNotifierProvider(create: (context) => EntradaDiarioViewModel()),
        ChangeNotifierProvider(create: (context) => UsuarioViewModel()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mi Diario',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
          useMaterial3: true,
        ),
        home: LoginScreen(),
      ),
    );
  }
}

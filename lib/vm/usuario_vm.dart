import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mi_diario/models/models.dart';
import 'package:mi_diario/services/api_service.dart';

class UsuarioViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Usuario> _usuarios = [];
  List<Usuario> get usuarios => _usuarios;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setBusy(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchUsuarios() async {
    setBusy(true);
    var response = await _apiService.get('/usuarios');
    if (response.statusCode == 200) {
      var usuariosData = json.decode(response.body) as List;
      _usuarios = usuariosData.map((data) => Usuario.fromJson(data)).toList();
    }
    setBusy(false);
  }

  Future<void> addUsuario(Usuario usuario) async {
    setBusy(true);
    await _apiService.post('/usuarios', usuario.toJson());
    setBusy(false);
  }

  Future<void> updateUsuario(String id, Usuario usuario) async {
    setBusy(true);
    await _apiService.put('/usuarios/$id', usuario.toJson());
    setBusy(false);
  }

  Future<void> deleteUsuario(String id) async {
    setBusy(true);
    await _apiService.delete('/usuarios/$id');
    setBusy(false);
  }

  Future<bool> login(String email, String password) async {
    setBusy(true);
    var response = await _apiService
        .post('/login', {'email': email, 'password': password});
    setBusy(false);
    return response.statusCode == 200;
  }
}

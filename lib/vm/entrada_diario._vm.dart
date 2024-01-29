import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mi_diario/models/models.dart';
import 'package:mi_diario/services/api_service.dart';

class EntradaDiarioViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<EntradaDiario> _entradas = [];
  List<EntradaDiario> get entradas => _entradas;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  EntradaDiarioViewModel() {
    fetchEntradasDiario();
  }

  void setBusy(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchEntradasDiario() async {
    setBusy(true);
    var response = await _apiService.get('/entradasDiario');
    if (response.statusCode == 200) {
      var entradasData = json.decode(response.body) as List;
      _entradas =
          entradasData.map((data) => EntradaDiario.fromJson(data)).toList();
    }
    setBusy(false);
  }

  Future<void> addEntradaDiarioConDetalles(
      EntradaDiario entrada, String estadoAnimo, List<String> habitos) async {
    setBusy(true);

    entrada.etiquetas = ['emociones:$estadoAnimo'];
    entrada.etiquetas?.addAll(habitos.map((habito) => 'habito:$habito'));
    entrada.fechaCreacion = DateTime.now();

    var payload = entrada.toJson();

    print(payload);
    await _apiService.post('/entradasDiario', payload);

    setBusy(false);
  }

  Future<void> updateEntradaDiario(String id, EntradaDiario entrada) async {
    setBusy(true);
    await _apiService.put('/entradasDiario/$id', entrada.toJson());
    setBusy(false);
  }

  Future<void> deleteEntradaDiario(String id) async {
    setBusy(true);
    await _apiService.delete('/entradasDiario/$id');
    setBusy(false);
  }
}

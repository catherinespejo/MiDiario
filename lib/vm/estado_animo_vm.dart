import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mi_diario/models/models.dart';
import 'package:mi_diario/services/api_service.dart';


class EstadoAnimoViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<EstadoAnimo> _estadosAnimo = [];
  List<EstadoAnimo> get estadosAnimo => _estadosAnimo;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setBusy(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchEstadosAnimo() async {
    setBusy(true);
    var response = await _apiService.get('/estadosAnimo');
    if (response.statusCode == 200) {
      var estadosData = json.decode(response.body) as List;
      _estadosAnimo =
          estadosData.map((data) => EstadoAnimo.fromJson(data)).toList();
    }
    setBusy(false);
  }

  Future<void> addEstadoAnimo(EstadoAnimo estadoAnimo) async {
    setBusy(true);
    await _apiService.post('/estadosAnimo', estadoAnimo.toJson());
    setBusy(false);
  }

  Future<void> updateEstadoAnimo(String id, EstadoAnimo estadoAnimo) async {
    setBusy(true);
    await _apiService.put('/estadosAnimo/$id', estadoAnimo.toJson());
    setBusy(false);
  }

  Future<void> deleteEstadoAnimo(String id) async {
    setBusy(true);
    await _apiService.delete('/estadosAnimo/$id');
    setBusy(false);
  }
}

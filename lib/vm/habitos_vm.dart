import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mi_diario/models/models.dart';
import 'package:mi_diario/services/api_service.dart';


class HabitoViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Habito> _habitos = [];
  List<Habito> get habitos => _habitos;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setBusy(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchHabitos() async {
    setBusy(true);
    var response = await _apiService.get('/habitos');
    if (response.statusCode == 200) {
      var habitosData = json.decode(response.body) as List;
      _habitos = habitosData.map((data) => Habito.fromJson(data)).toList();
    }
    setBusy(false);
  }

  Future<void> addHabito(Habito habito) async {
    setBusy(true);
    await _apiService.post('/habitos', habito.toJson());
    setBusy(false);
  }

  Future<void> updateHabito(String id, Habito habito) async {
    setBusy(true);
    await _apiService.put('/habitos/$id', habito.toJson());
    setBusy(false);
  }

  Future<void> deleteHabito(String id) async {
    setBusy(true);
    await _apiService.delete('/habitos/$id');
    setBusy(false);
  }
}

import 'dart:async';

import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/utils/db_helper.dart';

class HomeBloc {
  final _strMenuBawah = StreamController<int>.broadcast();
  Stream<int> get streamMenuBawah => _strMenuBawah.stream;

  void fetchMenuBawah(int menu) async {
    _strMenuBawah.sink.add(menu);
  }

  final _strPage = StreamController<String>.broadcast();
  Stream<String> get streamPage => _strPage.stream;

  void fetchPage(String page) async {
    _strPage.sink.add(page);
  }

  Future<List<PelatihanModel>> getPelatihans(String nik) async {
    List<PelatihanModel> list = [];
    var a = await DBHelper.getDaftar(
      methodeRequest: MethodeRequest.post,
      rute: 'pelatihan',
      mode: 'get',
      body: {'nik': nik},
    );
    for (var el in a) {
      var b = PelatihanModel.dariMap(el);
      list.add(b);
    }
    return list;
  }

  void dispose() {
    _strPage.close();
    _strMenuBawah.close();
  }
}

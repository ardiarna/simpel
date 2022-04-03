import 'dart:async';

import 'package:simpel/models/bumdes_model.dart';
import 'package:simpel/utils/db_helper.dart';

class BumdesBloc {
  Future<BumdesModel> get(String nik) async {
    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'bumdes',
      mode: 'get',
      body: {'nik': nik},
    );
    return a != null ? BumdesModel.dariMap(a) : BumdesModel();
  }

  Future<Map<String, dynamic>> edit(BumdesModel mod) async {
    var map = mod.keMap();
    var a = await DBHelper.setData(
      rute: 'bumdes',
      mode: 'edit',
      body: map,
    );
    return a;
  }

  final _str = StreamController<BumdesModel>.broadcast();
  Stream<BumdesModel> get stream => _str.stream;

  void fetch(BumdesModel nilai) async {
    _str.sink.add(nilai);
  }

  Future<KedudukanModel> getKedudukan(String nik) async {
    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'bumdes',
      mode: 'getkedudukan',
      body: {'nik': nik},
    );
    return a != null ? KedudukanModel.dariMap(a) : KedudukanModel();
  }

  Future<Map<String, dynamic>> editKedudukan(KedudukanModel mod) async {
    var map = mod.keMap();
    var a = await DBHelper.setData(
      rute: 'bumdes',
      mode: 'editkedudukan',
      body: map,
    );
    return a;
  }

  final _strKedudukan = StreamController<KedudukanModel>.broadcast();
  Stream<KedudukanModel> get streamKedudukan => _strKedudukan.stream;

  void fetchKedudukan(KedudukanModel nilai) async {
    _strKedudukan.sink.add(nilai);
  }

  void dispose() {
    _str.close();
    _strKedudukan.close();
  }
}

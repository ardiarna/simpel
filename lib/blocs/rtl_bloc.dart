import 'dart:async';

import 'package:simpel/models/rtl_real_model.dart';
import 'package:simpel/models/rtl_target_model.dart';
import 'package:simpel/utils/db_helper.dart';

class RTLBloc {
  final String _dirRTL = DBHelper.dirBase + 'filelms/01/rtl/';
  String get dirRTL => _dirRTL;

  Future<List<RTLtargetModel>> getTargets(
    String nik,
    String kode,
  ) async {
    List<RTLtargetModel> list = [];
    var a = await DBHelper.getDaftar(
      methodeRequest: MethodeRequest.post,
      rute: 'rtl',
      mode: 'target',
      body: {'nik': nik, 'kode': kode},
    );
    for (var el in a) {
      var b = RTLtargetModel.dariMap(el);
      list.add(b);
    }
    return list;
  }

  Future<RTLtargetModel> getTargetId(
    String nik,
    String kode,
    String id,
  ) async {
    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'rtl',
      mode: 'target',
      body: {'nik': nik, 'kode': kode, 'id': id},
    );
    return a != null ? RTLtargetModel.dariMap(a) : RTLtargetModel();
  }

  Future<Map<String, dynamic>> addTarget(RTLtargetModel model) async {
    var map = model.keMap();
    var a = await DBHelper.setData(
      rute: 'rtl',
      mode: 'addtarget',
      body: map,
    );
    return a;
  }

  Future<Map<String, dynamic>> ediTarget(RTLtargetModel model) async {
    var map = model.keMap();
    var a = await DBHelper.setData(
      rute: 'rtl',
      mode: 'edittarget',
      body: map,
    );
    return a;
  }

  Future<Map<String, dynamic>> delTarget(RTLtargetModel model) async {
    var map = model.keMap();
    var a = await DBHelper.setData(
      rute: 'rtl',
      mode: 'deltarget',
      body: map,
    );
    return a;
  }

  final _strTarget = StreamController<List<RTLtargetModel>>.broadcast();
  Stream<List<RTLtargetModel>> get streamTarget => _strTarget.stream;

  void fetchTarget(List<RTLtargetModel> list) async {
    _strTarget.sink.add(list);
  }

  Future<List<RTLrealModel>> getReals(
    String nik,
    String kode,
  ) async {
    List<RTLrealModel> list = [];
    var a = await DBHelper.getDaftar(
      methodeRequest: MethodeRequest.post,
      rute: 'rtl',
      mode: 'real',
      body: {'nik': nik, 'kode': kode},
    );
    for (var el in a) {
      var b = RTLrealModel.dariMap(el);
      list.add(b);
    }
    return list;
  }

  Future<List<RTLrealModel>> getRealHistory(
    String taretId,
  ) async {
    List<RTLrealModel> list = [];
    var a = await DBHelper.getDaftar(
      methodeRequest: MethodeRequest.post,
      rute: 'rtl',
      mode: 'real',
      body: {'target_id': taretId},
    );
    for (var el in a) {
      var b = RTLrealModel.dariMap(el);
      list.add(b);
    }
    return list;
  }

  Future<RTLrealModel> getRealId(
    String nik,
    String kode,
    String id,
  ) async {
    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'rtl',
      mode: 'real',
      body: {'nik': nik, 'kode': kode, 'id': id},
    );
    return a != null ? RTLrealModel.dariMap(a) : RTLrealModel();
  }

  Future<Map<String, dynamic>> addReal(RTLrealModel model) async {
    var map = model.keMap();
    Map<String, dynamic> a = {};
    if (map['real_file'] != null && map['real_file'] != '') {
      a = await DBHelper.setData(
        methodeRequest: MethodeRequest.multipartRequest,
        rute: 'rtl',
        mode: 'addreal',
        body: map,
        filePath: {'lampiran': map['real_file']!},
      );
    } else {
      a = await DBHelper.setData(
        rute: 'rtl',
        mode: 'addreal',
        body: map,
      );
    }
    return a;
  }

  Future<Map<String, dynamic>> ediReal(RTLrealModel model) async {
    var map = model.keMap();
    Map<String, dynamic> a = {};
    if (map['real_file'] != null && map['real_file'] != '') {
      a = await DBHelper.setData(
        methodeRequest: MethodeRequest.multipartRequest,
        rute: 'rtl',
        mode: 'editreal',
        body: map,
        filePath: {'lampiran': map['real_file']!},
      );
    } else {
      a = await DBHelper.setData(
        rute: 'rtl',
        mode: 'editreal',
        body: map,
      );
    }
    return a;
  }

  Future<Map<String, dynamic>> delReal(RTLrealModel model) async {
    var map = model.keMap();
    var a = await DBHelper.setData(
      rute: 'rtl',
      mode: 'delreal',
      body: map,
    );
    return a;
  }

  final _strReal = StreamController<List<RTLrealModel>>.broadcast();
  Stream<List<RTLrealModel>> get streamReal => _strReal.stream;

  void fetchReal(List<RTLrealModel> list) async {
    _strReal.sink.add(list);
  }

  final _strTanggal = StreamController<DateTime>.broadcast();
  Stream<DateTime> get streamTanggal => _strTanggal.stream;
  void fetchTanggal(DateTime nilai) async {
    _strTanggal.sink.add(nilai);
  }

  final _strRencanaLabel = StreamController<String>.broadcast();
  Stream<String> get streamRencanaLabel => _strRencanaLabel.stream;
  void fetchRencanaLabel(String nilai) async {
    _strRencanaLabel.sink.add(nilai);
  }

  final _strFile = StreamController<String>.broadcast();
  Stream<String> get streamFile => _strFile.stream;
  void fetchFile(String nilai) async {
    _strFile.sink.add(nilai);
  }

  final _strCapaian = StreamController<double>.broadcast();
  Stream<double> get streamCapaian => _strCapaian.stream;
  void fetchCapaian(double nilai) async {
    _strCapaian.sink.add(nilai);
  }

  void dispose() {
    _strTarget.close();
    _strReal.close();
    _strTanggal.close();
    _strRencanaLabel.close();
    _strFile.close();
    _strCapaian.close();
  }
}

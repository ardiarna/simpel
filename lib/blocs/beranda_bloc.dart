import 'dart:async';

import 'package:simpel/models/giat_model.dart';
import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/models/rekrutmen_model.dart';
import 'package:simpel/models/slide_model.dart';
import 'package:simpel/utils/db_helper.dart';

class BerandaBloc {
  final String _dirImageSlid = DBHelper.dirImage + 'slider/mobile/';
  String get dirImageSlid => _dirImageSlid;

  final String _dirImageGiat = DBHelper.dirImage + 'pelatihan/mobile/';
  String get dirImageGiat => _dirImageGiat;

  Future<List<SlidModel>> getSlides() async {
    List<SlidModel> list = [];
    var a = await DBHelper.getDaftar(
      rute: 'combo',
      mode: 'slider',
    );
    for (var el in a) {
      var b = SlidModel.dariMap(el);
      list.add(b);
    }
    return list;
  }

  final _strCurrentSlid = StreamController<int>.broadcast();
  Stream<int> get streamCurrentSlid => _strCurrentSlid.stream;
  void fetchCurentSlid(int idx) async {
    _strCurrentSlid.sink.add(idx);
  }

  final _strShowSlid = StreamController<bool>.broadcast();
  Stream<bool> get streamShowSlid => _strShowSlid.stream;
  void fetchShowSlid(bool nilai) async {
    _strShowSlid.sink.add(nilai);
  }

  Future<List<GiatModel>> getGiates() async {
    List<GiatModel> list = [];
    var a = await DBHelper.getDaftar(
      rute: 'combo',
      mode: 'giat',
    );
    for (var el in a) {
      var b = GiatModel.dariMap(el);
      list.add(b);
    }
    return list;
  }

  Future<List<PelatihanModel>> getPelatihanTeam(String nik) async {
    List<PelatihanModel> list = [];
    var a = await DBHelper.getDaftar(
      methodeRequest: MethodeRequest.post,
      rute: 'team',
      mode: 'pelatihan',
      body: {'nik': nik},
    );
    for (var el in a) {
      var b = PelatihanModel.dariMap(el);
      list.add(b);
    }
    return list;
  }

  final _strPelatihanTeam = StreamController<List<PelatihanModel>>.broadcast();
  Stream<List<PelatihanModel>> get streamPelatihanTeam =>
      _strPelatihanTeam.stream;
  void fetchPelatihanTeam(List<PelatihanModel> list) async {
    _strPelatihanTeam.sink.add(list);
  }

  Future<RekrutmenModel> getRekrutmenId(String kode) async {
    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'rekrutmen',
      mode: 'get',
      body: {'kode': kode},
    );
    return a != null ? RekrutmenModel.dariMap(a) : RekrutmenModel();
  }

  void dispose() {
    _strShowSlid.close();
    _strCurrentSlid.close();
    _strPelatihanTeam.close();
  }
}

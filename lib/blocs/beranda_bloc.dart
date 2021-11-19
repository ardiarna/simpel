import 'dart:async';

import 'package:simpel/models/giat_model.dart';
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

  void dispose() {
    _strShowSlid.close();
    _strCurrentSlid.close();
  }
}

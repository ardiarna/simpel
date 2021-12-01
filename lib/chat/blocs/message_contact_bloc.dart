import 'dart:async';

import 'package:simpel/models/member_model.dart';
import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/utils/db_helper.dart';

class MessageContactBloc {
  final String _dirImageMember = DBHelper.dirImage + 'member/';
  String get dirImageMember => _dirImageMember;

  final String _dirImageTeam = DBHelper.dirImage + 'team/';
  String get dirImageTeam => _dirImageTeam;

  Future<List<PelatihanModel>> getPelatihans(MemberModel member) async {
    List<PelatihanModel> list = [];
    var a = await DBHelper.getDaftar(
      methodeRequest: MethodeRequest.post,
      rute: member.kategori == 'team' ? 'team' : 'pelatihan',
      mode: member.kategori == 'team' ? 'pelatihan' : 'get',
      body: {'nik': member.nik},
    );
    for (var el in a) {
      var b = PelatihanModel.dariMap(el);
      list.add(b);
    }
    return list;
  }

  Future<List<PersonPSMModel>> getPSM(String kode) async {
    List<PersonPSMModel> list = [];
    var a = await DBHelper.getDaftar(
      methodeRequest: MethodeRequest.post,
      rute: 'pelatihan',
      mode: 'psm',
      body: {'kode': kode},
    );
    for (var el in a) {
      var b = PersonPSMModel.dariMap(el);
      list.add(b);
    }
    return list;
  }

  final _strPSM = StreamController<List<PersonPSMModel>>.broadcast();
  Stream<List<PersonPSMModel>> get streamPSM => _strPSM.stream;

  void fetchPSM(List<PersonPSMModel> list) async {
    _strPSM.sink.add(list);
  }

  Future<List<PersonPesertaModel>> getPeserta(String kode) async {
    List<PersonPesertaModel> list = [];
    var a = await DBHelper.getDaftar(
      methodeRequest: MethodeRequest.post,
      rute: 'pelatihan',
      mode: 'peserta',
      body: {'kode': kode},
    );
    for (var el in a) {
      var b = PersonPesertaModel.dariMap(el);
      list.add(b);
    }
    return list;
  }

  final _strPeserta = StreamController<List<PersonPesertaModel>>.broadcast();
  Stream<List<PersonPesertaModel>> get streamPeserta => _strPeserta.stream;

  void fetchPeserta(List<PersonPesertaModel> list) async {
    _strPeserta.sink.add(list);
  }

  void dispose() {
    _strPSM.close();
    _strPeserta.close();
  }
}

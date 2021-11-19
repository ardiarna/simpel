import 'dart:async';

import 'package:simpel/models/member_model.dart';
import 'package:simpel/utils/af_combobox.dart';
import 'package:simpel/utils/db_helper.dart';

class MemberBloc {
  final String _dirImageMember = DBHelper.dirImage + 'member/';
  String get dirImageMember => _dirImageMember;

  Future<MemberModel> getMember(String nik) async {
    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'member',
      mode: 'get',
      body: {'nik': nik},
    );
    return a != null ? MemberModel.dariMap(a) : MemberModel();
  }

  final _strMember = StreamController<MemberModel>.broadcast();
  Stream<MemberModel> get streamMember => _strMember.stream;
  void fetchMember(MemberModel list) async {
    _strMember.sink.add(list);
  }

  Future<List<Opsi>> getOpsies({
    required String rute,
    required String mode,
  }) async {
    List<Opsi> list = [];
    var a = await DBHelper.getDaftar(
      rute: rute,
      mode: mode,
    );
    for (var el in a) {
      var b = Opsi.dariMap(el);
      list.add(b);
    }
    return list;
  }

  Future<Opsi> getOpsiId({
    required String rute,
    required String mode,
    required String id,
  }) async {
    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: rute,
      mode: mode,
      body: {'id': id},
    );
    return a != null ? Opsi.dariMap(a) : Opsi();
  }

  Future<Map<String, dynamic>> signIn({
    required String nik,
    required String password,
  }) async {
    var a = await DBHelper.setData(
      rute: 'member',
      mode: 'login',
      body: {'nik': nik, 'password': password},
    );
    return a;
  }

  Future<Map<String, dynamic>> signUp(MemberModel member) async {
    var map = member.keMap();
    var a = await DBHelper.setData(
      methodeRequest: MethodeRequest.multipartRequest,
      rute: 'member',
      mode: 'add',
      body: map,
      filePath: {'foto': map['pas_foto']!},
    );
    return a;
  }

  Future<Map<String, dynamic>> editBiodata(MemberModel member) async {
    var map = member.keMap();
    var a = await DBHelper.setData(
      rute: 'member',
      mode: 'edit',
      body: map,
    );
    return a;
  }

  Future<Map<String, dynamic>> editPassword({
    required String nik,
    required String pwdLama,
    required String pwdBaru,
  }) async {
    var a = await DBHelper.setData(
      rute: 'member',
      mode: 'changepwd',
      body: {
        'nik': nik,
        'password_lama': pwdLama,
        'password_baru': pwdBaru,
      },
    );
    return a;
  }

  Future<Map<String, dynamic>> editFoto({
    required String nik,
    required String pathFoto,
  }) async {
    var a = await DBHelper.setData(
      methodeRequest: MethodeRequest.multipartRequest,
      rute: 'member',
      mode: 'changefoto',
      body: {'nik': nik},
      filePath: {'foto': pathFoto},
    );
    return a;
  }

  final _strTampilPassword = StreamController<bool>.broadcast();
  Stream<bool> get streamTampilPassword => _strTampilPassword.stream;
  void fetchTampilPassword(bool a) async {
    _strTampilPassword.sink.add(a);
  }

  final _strTampilPasswordBaru = StreamController<bool>.broadcast();
  Stream<bool> get streamTampilPasswordBaru => _strTampilPasswordBaru.stream;
  void fetchTampilPasswordBaru(bool a) async {
    _strTampilPasswordBaru.sink.add(a);
  }

  final _strTampilPasswordKonf = StreamController<bool>.broadcast();
  Stream<bool> get streamTampilPasswordKonf => _strTampilPasswordKonf.stream;
  void fetchTampilPasswordKonf(bool a) async {
    _strTampilPasswordKonf.sink.add(a);
  }

  final _strTglLahir = StreamController<DateTime>.broadcast();
  Stream<DateTime> get streamTglLahir => _strTglLahir.stream;
  void fetchTglLahir(DateTime nilai) async {
    _strTglLahir.sink.add(nilai);
  }

  final _strFoto = StreamController<String>.broadcast();
  Stream<String> get streamFoto => _strFoto.stream;
  void fetchFoto(String nilai) async {
    _strFoto.sink.add(nilai);
  }

  final _strKelamin = StreamController<String>.broadcast();
  Stream<String> get streamKelamin => _strKelamin.stream;
  void fetchKelamin(String nilai) async {
    _strKelamin.sink.add(nilai);
  }

  final _strAgama = StreamController<String>.broadcast();
  Stream<String> get streamAgama => _strAgama.stream;
  void fetchAgama(String nilai) async {
    _strAgama.sink.add(nilai);
  }

  final _strKawin = StreamController<String>.broadcast();
  Stream<String> get streamKawin => _strKawin.stream;
  void fetchKawin(String nilai) async {
    _strKawin.sink.add(nilai);
  }

  final _strPendidikan = StreamController<String>.broadcast();
  Stream<String> get streamPendidikan => _strPendidikan.stream;
  void fetchPendidikan(String nilai) async {
    _strPendidikan.sink.add(nilai);
  }

  final _strProvinsi = StreamController<String>.broadcast();
  Stream<String> get streamProvinsi => _strProvinsi.stream;
  void fetchProvinsi(String nilai) async {
    _strProvinsi.sink.add(nilai);
  }

  final _strKabupaten = StreamController<String>.broadcast();
  Stream<String> get streamKabupaten => _strKabupaten.stream;
  void fetchKabupaten(String nilai) async {
    _strKabupaten.sink.add(nilai);
  }

  final _strKecamatan = StreamController<String>.broadcast();
  Stream<String> get streamKecamatan => _strKecamatan.stream;
  void fetchKecamatan(String nilai) async {
    _strKecamatan.sink.add(nilai);
  }

  final _strKelurahan = StreamController<String>.broadcast();
  Stream<String> get streamKelurahan => _strKelurahan.stream;
  void fetchKelurahan(String nilai) async {
    _strKelurahan.sink.add(nilai);
  }

  void dispose() {
    _strMember.close();
    _strTampilPassword.close();
    _strTampilPasswordBaru.close();
    _strTampilPasswordKonf.close();
    _strTglLahir.close();
    _strFoto.close();
    _strKelamin.close();
    _strAgama.close();
    _strKawin.close();
    _strPendidikan.close();
    _strProvinsi.close();
    _strKabupaten.close();
    _strKecamatan.close();
    _strKelurahan.close();
  }
}

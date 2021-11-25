import 'dart:async';

import 'package:simpel/models/evaluasi_model.dart';
import 'package:simpel/models/giat_model.dart';
import 'package:simpel/models/kuis_model.dart';
import 'package:simpel/models/materi_model.dart';
import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/models/rekrutmen_model.dart';
import 'package:simpel/models/survey_model.dart';
import 'package:simpel/models/tugas_model.dart';
import 'package:simpel/utils/db_helper.dart';

class PelatihanBloc {
  final String _dirImageMember = DBHelper.dirImage + 'member/';
  String get dirImageMember => _dirImageMember;

  final String _dirMateri = DBHelper.dirBase + 'filelms/01/materi/';
  String get dirMateri => _dirMateri;

  final String _dirTugas = DBHelper.dirBase + 'filelms/01/tugas_psm/';
  String get dirTugas => _dirTugas;

  final String _dirTugasUpload = DBHelper.dirBase + 'filelms/01/tugas_peserta/';
  String get dirTugasUpload => _dirTugasUpload;

  final String _dirSertifikat = DBHelper.dirBase + 'filelms/01/sertifikat/';
  String get dirSertifikat => _dirSertifikat;

  final _strMenu = StreamController<int>.broadcast();
  Stream<int> get streamMenu => _strMenu.stream;

  void fetchMenu(int menu) async {
    _strMenu.sink.add(menu);
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

  Future<PelatihanModel> getPelatihanId(String nik, String kode) async {
    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'pelatihan',
      mode: 'get',
      body: {'nik': nik, 'kode': kode},
    );
    return a != null ? PelatihanModel.dariMap(a) : PelatihanModel();
  }

  Future<List<MateriModel>> getMateri(String kode) async {
    List<MateriModel> list = [];
    var a = await DBHelper.getDaftar(
      methodeRequest: MethodeRequest.post,
      rute: 'pelatihan',
      mode: 'materi',
      body: {'kode': kode},
    );
    for (var el in a) {
      var b = MateriModel.dariMap(el);
      list.add(b);
    }
    return list;
  }

  Future<List<TugasModel>> getTugas(String kode) async {
    List<TugasModel> list = [];
    var a = await DBHelper.getDaftar(
      methodeRequest: MethodeRequest.post,
      rute: 'pelatihan',
      mode: 'tugas',
      body: {'kode': kode},
    );
    for (var el in a) {
      var b = TugasModel.dariMap(el);
      list.add(b);
    }
    return list;
  }

  Future<List<TugasDetailModel>> getTugasDetail(String nik, String kode) async {
    List<TugasDetailModel> list = [];
    var a = await DBHelper.getDaftar(
      methodeRequest: MethodeRequest.post,
      rute: 'pelatihan',
      mode: 'tugasdetail',
      body: {'nik': nik, 'kode': kode},
    );
    for (var el in a) {
      var b = TugasDetailModel.dariMap(el);
      list.add(b);
    }
    return list;
  }

  Future<List<KuisModel>> getKuis(String kode) async {
    List<KuisModel> list = [];
    var a = await DBHelper.getDaftar(
      methodeRequest: MethodeRequest.post,
      rute: 'pelatihan',
      mode: 'kuis',
      body: {'kode': kode},
    );
    for (var el in a) {
      var b = KuisModel.dariMap(el);
      list.add(b);
    }
    return list;
  }

  Future<List<KuisDetailModel>> getKuisDetail(String nik, String kode) async {
    List<KuisDetailModel> list = [];
    var a = await DBHelper.getDaftar(
      methodeRequest: MethodeRequest.post,
      rute: 'pelatihan',
      mode: 'kuisdetail',
      body: {'nik': nik, 'kode': kode},
    );
    for (var el in a) {
      var b = KuisDetailModel.dariMap(el);
      list.add(b);
    }
    return list;
  }

  Future<List<SurveyModel>> getSurvey(String nik, String kode) async {
    List<SurveyModel> list = [];
    var a = await DBHelper.getDaftar(
      methodeRequest: MethodeRequest.post,
      rute: 'pelatihan',
      mode: 'survey',
      body: {'nik': nik, 'kode': kode},
    );
    for (var el in a) {
      var b = SurveyModel.dariMap(el);
      list.add(b);
    }
    return list;
  }

  Future<List<EvaluasiModel>> getEvaluasi(String nik, String kode) async {
    List<EvaluasiModel> list = [];
    var a = await DBHelper.getDaftar(
      methodeRequest: MethodeRequest.post,
      rute: 'pelatihan',
      mode: 'evaluasi',
      body: {'nik': nik, 'kode': kode},
    );
    for (var el in a) {
      var b = EvaluasiModel.dariMap(el);
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

  Future<RekrutmenModel> getRekrutmen(String kode) async {
    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'rekrutmen',
      mode: 'get',
      body: {'kode': kode},
    );
    return a != null ? RekrutmenModel.dariMap(a) : RekrutmenModel();
  }

  Future<GiatModel> getGiatId(String kode) async {
    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'combo',
      mode: 'giat',
      body: {'kode': kode},
    );
    return a != null ? GiatModel.dariMap(a) : GiatModel();
  }

  void dispose() {
    _strPage.close();
    _strMenu.close();
    _strPSM.close();
    _strPeserta.close();
  }
}

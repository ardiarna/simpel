import 'package:simpel/utils/af_convert.dart';

class PelatihanModel {
  String kode;
  String nama;
  int tahun;
  int angkatan;
  String fevaluasi;
  String fsurvey;
  String fileSertifikat;
  String giatKode;

  PelatihanModel({
    this.kode = '',
    this.nama = '',
    this.tahun = 0,
    this.angkatan = 0,
    this.fevaluasi = '',
    this.fsurvey = '',
    this.fileSertifikat = '',
    this.giatKode = '',
  });

  factory PelatihanModel.dariMap(Map<String, dynamic> map) {
    return PelatihanModel(
      kode: AFconvert.keString(map['kode']),
      nama: AFconvert.keString(map['nama']),
      tahun: AFconvert.keInt(map['tahun']),
      angkatan: AFconvert.keInt(map['angkatan']),
      fevaluasi: AFconvert.keString(map['fevaluasi']),
      fsurvey: AFconvert.keString(map['fsurvey']),
      fileSertifikat: AFconvert.keString(map['file_sertifikat']),
      giatKode: AFconvert.keString(map['kd_giat']),
    );
  }

  Map<String, dynamic> keMap() {
    Map<String, dynamic> map = {
      'kode': kode,
      'nama': nama,
      'tahun': tahun,
      'angkatan': angkatan,
      'fevaluasi': fevaluasi,
      'fsurvey': fsurvey,
      'file_sertifikat': fileSertifikat,
      'kd_giat': giatKode,
    };
    return map;
  }
}

class PersonPSMModel {
  String posisi;
  String nama;

  PersonPSMModel({
    this.posisi = '',
    this.nama = '',
  });

  factory PersonPSMModel.dariMap(Map<String, dynamic> map) {
    return PersonPSMModel(
      posisi: AFconvert.keString(map['posisi']),
      nama: AFconvert.keString(map['nama']),
    );
  }

  Map<String, dynamic> keMap() {
    Map<String, dynamic> map = {
      'posisi': posisi,
      'nama': nama,
    };
    return map;
  }
}

class PersonPesertaModel {
  String posisi;
  String nama;

  PersonPesertaModel({
    this.posisi = '',
    this.nama = '',
  });

  factory PersonPesertaModel.dariMap(Map<String, dynamic> map) {
    return PersonPesertaModel(
      posisi: AFconvert.keString(map['posisi']),
      nama: AFconvert.keString(map['nama']),
    );
  }

  Map<String, dynamic> keMap() {
    Map<String, dynamic> map = {
      'posisi': posisi,
      'nama': nama,
    };
    return map;
  }
}

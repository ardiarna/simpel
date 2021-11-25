import 'package:simpel/utils/af_convert.dart';

class PelatihanModel {
  String kode;
  String nama;
  int tahun;
  int angkatan;
  String fstatus;
  String fevaluasi;
  String fsurvey;
  String fileSertifikat;
  String giatKode;

  PelatihanModel({
    this.kode = '',
    this.nama = '',
    this.tahun = 0,
    this.angkatan = 0,
    this.fstatus = '',
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
      fstatus: AFconvert.keString(map['fstatus']),
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
      'fstatus': fstatus,
      'fevaluasi': fevaluasi,
      'fsurvey': fsurvey,
      'file_sertifikat': fileSertifikat,
      'kd_giat': giatKode,
    };
    return map;
  }
}

class PersonPSMModel {
  String nik;
  String nama;
  String foto;
  String posisi;

  PersonPSMModel({
    this.nik = '',
    this.nama = '',
    this.foto = '',
    this.posisi = '',
  });

  factory PersonPSMModel.dariMap(Map<String, dynamic> map) {
    return PersonPSMModel(
      nik: AFconvert.keString(map['nik']),
      nama: AFconvert.keString(map['nama']),
      foto: AFconvert.keString(map['pas_foto']),
      posisi: AFconvert.keString(map['posisi']),
    );
  }

  Map<String, dynamic> keMap() {
    Map<String, dynamic> map = {
      'nik': nik,
      'nama': nama,
      'pas_foto': foto,
      'posisi': posisi,
    };
    return map;
  }
}

class PersonPesertaModel {
  String nik;
  String nama;
  String foto;
  String posisi;

  PersonPesertaModel({
    this.nik = '',
    this.nama = '',
    this.foto = '',
    this.posisi = '',
  });

  factory PersonPesertaModel.dariMap(Map<String, dynamic> map) {
    return PersonPesertaModel(
      nik: AFconvert.keString(map['nik']),
      nama: AFconvert.keString(map['nama']),
      foto: AFconvert.keString(map['pas_foto']),
      posisi: AFconvert.keString(map['posisi']),
    );
  }

  Map<String, dynamic> keMap() {
    Map<String, dynamic> map = {
      'nik': nik,
      'nama': nama,
      'pas_foto': foto,
      'posisi': posisi,
    };
    return map;
  }
}

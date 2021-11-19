import 'package:simpel/utils/af_convert.dart';

class TugasModel {
  int id;
  String klasi;
  String root;
  DateTime? tanggal;
  String nama;
  String keterangan;
  String jenis;
  String url;
  String createdNik;
  String createdBy;
  String modifiedBy;
  DateTime? createdOn;
  DateTime? modifiedOn;

  TugasModel({
    this.id = 0,
    this.klasi = '',
    this.root = '',
    this.tanggal,
    this.nama = '',
    this.keterangan = '',
    this.jenis = '',
    this.url = '',
    this.createdNik = '',
    this.createdBy = '',
    this.modifiedBy = '',
    this.createdOn,
    this.modifiedOn,
  });

  factory TugasModel.dariMap(Map<String, dynamic> map) {
    return TugasModel(
      id: AFconvert.keInt(map['tug_id']),
      klasi: AFconvert.keString(map['tug_klasi']),
      root: AFconvert.keString(map['tug_root']),
      tanggal: AFconvert.keTanggal(map['tug_date']),
      nama: AFconvert.keString(map['tug_nama']),
      keterangan: AFconvert.keString(map['tug_ket']),
      jenis: AFconvert.keString(map['tug_jenis']),
      url: AFconvert.keString(map['tug_url']),
      createdNik: AFconvert.keString(map['created_nik']),
      createdBy: AFconvert.keString(map['created_by']),
      modifiedBy: AFconvert.keString(map['modified_by']),
      createdOn: AFconvert.keTanggal(map['created_on']),
      modifiedOn: AFconvert.keTanggal(map['modified_on']),
    );
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'tug_id': AFconvert.keString(id),
      'tug_klasi': klasi,
      'tug_root': root,
      'tug_date': AFconvert.keString(tanggal),
      'tug_nama': nama,
      'tug_ket': keterangan,
      'tug_jenis': jenis,
      'tug_url': url,
      'created_nik': createdNik,
      'created_by': createdBy,
      'modified_by': modifiedBy,
      'created_on': AFconvert.keString(createdOn),
      'modified_on': AFconvert.keString(modifiedOn),
    };
    return map;
  }
}

class TugasDetailModel {
  int id;
  String klasi;
  String root;
  String nik;
  String keterangan;
  String jenis;
  String url;
  String koreksi;
  String koreksiBy;
  String createdBy;
  String modifiedBy;
  DateTime? koreksiOn;
  DateTime? createdOn;
  DateTime? modifiedOn;

  TugasDetailModel({
    this.id = 0,
    this.klasi = '',
    this.root = '',
    this.nik = '',
    this.keterangan = '',
    this.jenis = '',
    this.url = '',
    this.koreksi = '',
    this.koreksiBy = '',
    this.createdBy = '',
    this.modifiedBy = '',
    this.koreksiOn,
    this.createdOn,
    this.modifiedOn,
  });

  factory TugasDetailModel.dariMap(Map<String, dynamic> map) {
    return TugasDetailModel(
      id: AFconvert.keInt(map['tugs_id']),
      klasi: AFconvert.keString(map['tugs_klasi']),
      root: AFconvert.keString(map['tugs_root']),
      nik: AFconvert.keString(map['tugs_nik']),
      keterangan: AFconvert.keString(map['tugs_ket']),
      jenis: AFconvert.keString(map['tugs_jenis']),
      url: AFconvert.keString(map['tugs_url']),
      koreksi: AFconvert.keString(map['tugs_koreksi']),
      koreksiBy: AFconvert.keString(map['tugs_koreksi_by']),
      createdBy: AFconvert.keString(map['created_by']),
      modifiedBy: AFconvert.keString(map['modified_by']),
      koreksiOn: AFconvert.keTanggal(map['tugs_koreksi_on']),
      createdOn: AFconvert.keTanggal(map['created_on']),
      modifiedOn: AFconvert.keTanggal(map['modified_on']),
    );
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'tugs_id': AFconvert.keString(id),
      'tugs_klasi': klasi,
      'tugs_root': root,
      'tugs_nik': nik,
      'tugs_ket': keterangan,
      'tugs_jenis': jenis,
      'tugs_url': url,
      'tugs_koreksi': koreksi,
      'tugs_koreksi_by': koreksi,
      'created_by': createdBy,
      'modified_by': modifiedBy,
      'tugs_koreksi_on': AFconvert.keString(koreksiOn),
      'created_on': AFconvert.keString(createdOn),
      'modified_on': AFconvert.keString(modifiedOn),
    };
    return map;
  }
}

import 'package:simpel/utils/af_convert.dart';

class BumdesModel {
  String nik;
  String nama;
  int tahun;
  String unitusaha;
  String omset;
  String jabatan;
  String jabperiode;
  DateTime? createdOn;
  DateTime? modifiedOn;

  BumdesModel({
    this.nik = '',
    this.nama = '',
    this.tahun = 0,
    this.unitusaha = '',
    this.omset = '',
    this.jabatan = '',
    this.jabperiode = '',
    DateTime? createdOn,
    DateTime? modifiedOn,
  });

  factory BumdesModel.dariMap(Map<String, dynamic> map) {
    return BumdesModel(
      nik: AFconvert.keString(map['nik']),
      nama: AFconvert.keString(map['bumdes_nama']),
      tahun: AFconvert.keInt(map['bumdes_tahun']),
      unitusaha: AFconvert.keString(map['bumdes_unitusaha']),
      omset: AFconvert.keString(map['bumdes_omset']),
      jabatan: AFconvert.keString(map['bumdes_jabatan']),
      jabperiode: AFconvert.keString(map['bumdes_jabperiode']),
      createdOn: AFconvert.keTanggal(map['created_on']),
      modifiedOn: AFconvert.keTanggal(map['modified_on']),
    );
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'nik': nik,
      'bumdes_nama': nama,
      'bumdes_tahun': AFconvert.keString(tahun),
      'bumdes_unitusaha': unitusaha,
      'bumdes_omset': omset,
      'bumdes_jabatan': jabatan,
      'bumdes_jabperiode': jabperiode,
      'created_on': AFconvert.keString(createdOn),
      'modified_on': AFconvert.keString(modifiedOn),
    };
    return map;
  }
}

class KedudukanModel {
  String nik;
  String jabatan;
  String periode;

  KedudukanModel({
    this.nik = '',
    this.jabatan = '',
    this.periode = '',
  });

  factory KedudukanModel.dariMap(Map<String, dynamic> map) {
    return KedudukanModel(
      nik: AFconvert.keString(map['nik']),
      jabatan: AFconvert.keString(map['jabatan']),
      periode: AFconvert.keString(map['periode']),
    );
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'nik': nik,
      'jabatan': jabatan,
      'periode': periode,
    };
    return map;
  }
}

import 'package:simpel/utils/af_convert.dart';

class SaranModel {
  String id;
  String kdroot;
  String nik;
  String psmNik;
  String psmNama;
  String psmSaran;
  DateTime? psmTanggal;

  SaranModel({
    this.id = '',
    this.kdroot = '',
    this.nik = '',
    this.psmNik = '',
    this.psmNama = '',
    this.psmTanggal,
    this.psmSaran = '',
  });

  factory SaranModel.dariMap(Map<String, dynamic> map) {
    return SaranModel(
      id: AFconvert.keString(map['saran_id']),
      kdroot: AFconvert.keString(map['kdroot']),
      nik: AFconvert.keString(map['nik']),
      psmNik: AFconvert.keString(map['psm_nik']),
      psmNama: AFconvert.keString(map['psm_nama']),
      psmSaran: AFconvert.keString(map['psm_saran']),
      psmTanggal: AFconvert.keTanggal(map['psm_tanggal']),
    );
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'saran_id': id,
      'kdroot': kdroot,
      'nik': nik,
      'psm_nik': psmNik,
      'psm_nama': psmNama,
      'psm_saran': psmSaran,
      'psm_tanggal': AFconvert.keString(psmTanggal),
    };
    return map;
  }
}

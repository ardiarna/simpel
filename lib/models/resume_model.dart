import 'package:simpel/utils/af_convert.dart';

class ResumeModel {
  String id;
  String kdroot;
  String nik;
  String psmNik;
  String psmNama;
  String psmResume;
  DateTime? psmTanggal;

  ResumeModel({
    this.id = '',
    this.kdroot = '',
    this.nik = '',
    this.psmNik = '',
    this.psmNama = '',
    this.psmTanggal,
    this.psmResume = '',
  });

  factory ResumeModel.dariMap(Map<String, dynamic> map) {
    return ResumeModel(
      id: AFconvert.keString(map['resume_id']),
      kdroot: AFconvert.keString(map['kdroot']),
      nik: AFconvert.keString(map['nik']),
      psmNik: AFconvert.keString(map['psm_nik']),
      psmNama: AFconvert.keString(map['psm_nama']),
      psmResume: AFconvert.keString(map['psm_resume']),
      psmTanggal: AFconvert.keTanggal(map['psm_tanggal']),
    );
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'resume_id': id,
      'kdroot': kdroot,
      'nik': nik,
      'psm_nik': psmNik,
      'psm_nama': psmNama,
      'psm_resume': psmResume,
      'psm_tanggal': AFconvert.keString(psmTanggal),
    };
    return map;
  }
}

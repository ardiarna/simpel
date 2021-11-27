import 'package:simpel/utils/af_convert.dart';

class RTLtargetModel {
  int id;
  String root;
  String nik;
  DateTime? tglAwal;
  DateTime? tglAkhir;
  String rencana;
  String keterangan;

  RTLtargetModel({
    this.id = 0,
    this.root = '',
    this.nik = '',
    this.tglAwal,
    this.tglAkhir,
    this.rencana = '',
    this.keterangan = '',
  });

  factory RTLtargetModel.dariMap(Map<String, dynamic> map) {
    return RTLtargetModel(
      id: AFconvert.keInt(map['target_id']),
      root: AFconvert.keString(map['kdroot']),
      nik: AFconvert.keString(map['nik']),
      tglAwal: AFconvert.keTanggal(map['target_tgl_awal']),
      tglAkhir: AFconvert.keTanggal(map['target_tgl_akhir']),
      rencana: AFconvert.keString(map['target_rencana']),
      keterangan: AFconvert.keString(map['target_keterangan']),
    );
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'target_id': AFconvert.keString(id),
      'kdroot': root,
      'nik': nik,
      'target_tgl_awal': AFconvert.keString(tglAwal),
      'target_tgl_akhir': AFconvert.keString(tglAkhir),
      'target_rencana': rencana,
      'target_keterangan': keterangan,
    };
    return map;
  }
}

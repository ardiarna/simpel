import 'package:simpel/utils/af_convert.dart';

class RTLtargetModel {
  int id;
  String root;
  String nik;
  DateTime? tanggal;
  String rencana;
  String keterangan;

  RTLtargetModel({
    this.id = 0,
    this.root = '',
    this.nik = '',
    this.tanggal,
    this.rencana = '',
    this.keterangan = '',
  });

  factory RTLtargetModel.dariMap(Map<String, dynamic> map) {
    return RTLtargetModel(
      id: AFconvert.keInt(map['target_id']),
      root: AFconvert.keString(map['kdroot']),
      nik: AFconvert.keString(map['nik']),
      tanggal: AFconvert.keTanggal(map['target_tanggal']),
      rencana: AFconvert.keString(map['target_rencana']),
      keterangan: AFconvert.keString(map['target_keterangan']),
    );
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'target_id': AFconvert.keString(id),
      'kdroot': root,
      'nik': nik,
      'target_tanggal': AFconvert.keString(tanggal),
      'target_rencana': rencana,
      'target_keterangan': keterangan,
    };
    return map;
  }
}

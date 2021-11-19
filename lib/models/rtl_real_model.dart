import 'package:simpel/utils/af_convert.dart';

class RTLrealModel {
  int id;
  int targetId;
  DateTime? tanggal;
  int capaian;
  String keterangan;
  String kendala;
  String file;
  String targetRencana;
  int jml;

  RTLrealModel({
    this.id = 0,
    this.targetId = 0,
    this.tanggal,
    this.capaian = 0,
    this.keterangan = '',
    this.kendala = '',
    this.file = '',
    this.targetRencana = '',
    this.jml = 0,
  });

  factory RTLrealModel.dariMap(Map<String, dynamic> map) {
    return RTLrealModel(
      id: AFconvert.keInt(map['real_id']),
      targetId: AFconvert.keInt(map['target_id']),
      tanggal: AFconvert.keTanggal(map['real_tanggal']),
      capaian: AFconvert.keInt(map['real_capaian']),
      keterangan: AFconvert.keString(map['real_keterangan']),
      kendala: AFconvert.keString(map['real_kendala']),
      file: AFconvert.keString(map['real_file']),
      targetRencana: AFconvert.keString(map['target_rencana']),
      jml: AFconvert.keInt(map['jml']),
    );
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'real_id': AFconvert.keString(id),
      'target_id': AFconvert.keString(targetId),
      'real_tanggal': AFconvert.keString(tanggal),
      'real_capaian': AFconvert.keString(capaian),
      'real_keterangan': keterangan,
      'real_kendala': kendala,
      'real_file': file,
      'target_rencana': targetRencana,
      'jml': AFconvert.keString(jml),
    };
    return map;
  }
}

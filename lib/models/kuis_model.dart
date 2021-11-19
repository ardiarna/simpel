import 'package:simpel/utils/af_convert.dart';

class KuisModel {
  int id;
  String klasi;
  String root;
  DateTime? tanggal;
  String nama;
  String keterangan;
  String jenis;
  String publish;
  String createdNik;
  String createdBy;
  String modifiedBy;
  DateTime? createdOn;
  DateTime? modifiedOn;

  KuisModel({
    this.id = 0,
    this.klasi = '',
    this.root = '',
    this.tanggal,
    this.nama = '',
    this.keterangan = '',
    this.jenis = '',
    this.publish = '',
    this.createdNik = '',
    this.createdBy = '',
    this.modifiedBy = '',
    this.createdOn,
    this.modifiedOn,
  });

  factory KuisModel.dariMap(Map<String, dynamic> map) {
    return KuisModel(
      id: AFconvert.keInt(map['ku_id']),
      klasi: AFconvert.keString(map['ku_klasi']),
      root: AFconvert.keString(map['ku_root']),
      tanggal: AFconvert.keTanggal(map['ku_date']),
      nama: AFconvert.keString(map['ku_nama']),
      keterangan: AFconvert.keString(map['ku_ket']),
      jenis: AFconvert.keString(map['ku_jenis']),
      publish: AFconvert.keString(map['ku_publish']),
      createdNik: AFconvert.keString(map['created_nik']),
      createdBy: AFconvert.keString(map['created_by']),
      modifiedBy: AFconvert.keString(map['modified_by']),
      createdOn: AFconvert.keTanggal(map['created_on']),
      modifiedOn: AFconvert.keTanggal(map['modified_on']),
    );
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'ku_id': AFconvert.keString(id),
      'ku_klasi': klasi,
      'ku_root': root,
      'ku_date': AFconvert.keString(tanggal),
      'ku_nama': nama,
      'ku_ket': keterangan,
      'ku_jenis': jenis,
      'ku_publish': publish,
      'created_nik': createdNik,
      'created_by': createdBy,
      'modified_by': modifiedBy,
      'created_on': AFconvert.keString(createdOn),
      'modified_on': AFconvert.keString(modifiedOn),
    };
    return map;
  }
}

class KuisDetailModel {
  int id;
  int headerId;
  int detailId;
  String answer;
  String key;
  String question;
  String pilihanA;
  String pilihanB;
  String pilihanC;
  String pilihanD;

  KuisDetailModel({
    this.id = 0,
    this.headerId = 0,
    this.detailId = 0,
    this.answer = '',
    this.key = '',
    this.question = '',
    this.pilihanA = '',
    this.pilihanB = '',
    this.pilihanC = '',
    this.pilihanD = '',
  });

  factory KuisDetailModel.dariMap(Map<String, dynamic> map) {
    return KuisDetailModel(
      id: AFconvert.keInt(map['kup_id']),
      headerId: AFconvert.keInt(map['kud_hid']),
      detailId: AFconvert.keInt(map['kud_id']),
      answer: AFconvert.keString(map['kup_answer']),
      key: AFconvert.keString(map['kud_key']),
      question: AFconvert.keString(map['kud_question']),
      pilihanA: AFconvert.keString(map['kud_a']),
      pilihanB: AFconvert.keString(map['kud_b']),
      pilihanC: AFconvert.keString(map['kud_c']),
      pilihanD: AFconvert.keString(map['kud_d']),
    );
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'kup_id': AFconvert.keString(id),
      'kud_hid': AFconvert.keString(headerId),
      'kud_id': AFconvert.keString(detailId),
      'kup_answer': answer,
      'kud_key': key,
      'kud_question': question,
      'kud_a': pilihanA,
      'kud_b': pilihanB,
      'kud_c': pilihanC,
      'kud_d': pilihanD,
    };
    return map;
  }
}

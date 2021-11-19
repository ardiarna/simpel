import 'package:simpel/utils/af_convert.dart';

class MateriModel {
  int id;
  String klasi;
  String root;
  String nama;
  String keterangan;
  String jenis;
  String url;
  String createdNik;
  String createdBy;
  String modifiedBy;
  DateTime? createdOn;
  DateTime? modifiedOn;

  MateriModel({
    this.id = 0,
    this.klasi = '',
    this.root = '',
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

  factory MateriModel.dariMap(Map<String, dynamic> map) {
    return MateriModel(
      id: AFconvert.keInt(map['mat_id']),
      klasi: AFconvert.keString(map['mat_klasi']),
      root: AFconvert.keString(map['mat_root']),
      nama: AFconvert.keString(map['mat_nama']),
      keterangan: AFconvert.keString(map['mat_ket']),
      jenis: AFconvert.keString(map['mat_jenis']),
      url: AFconvert.keString(map['mat_url']),
      createdNik: AFconvert.keString(map['created_nik']),
      createdBy: AFconvert.keString(map['created_by']),
      modifiedBy: AFconvert.keString(map['modified_by']),
      createdOn: AFconvert.keTanggal(map['created_on']),
      modifiedOn: AFconvert.keTanggal(map['modified_on']),
    );
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'mat_id': AFconvert.keString(id),
      'mat_klasi': klasi,
      'mat_root': root,
      'mat_nama': nama,
      'mat_ket': keterangan,
      'mat_jenis': jenis,
      'mat_url': url,
      'created_nik': createdNik,
      'created_by': createdBy,
      'modified_by': modifiedBy,
      'created_on': AFconvert.keString(createdOn),
      'modified_on': AFconvert.keString(modifiedOn),
    };
    return map;
  }
}

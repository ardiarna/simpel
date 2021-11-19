import 'package:simpel/utils/af_convert.dart';

class EvaluasiModel {
  int id;
  String klasi;
  String kode;
  String kategori;
  String tanya;
  String jenis;
  String nilai;
  String nik;
  DateTime? createdOn;

  EvaluasiModel({
    this.id = 0,
    this.klasi = '',
    this.kode = '',
    this.kategori = '',
    this.tanya = '',
    this.jenis = '',
    this.nilai = '',
    this.nik = '',
    this.createdOn,
  });

  factory EvaluasiModel.dariMap(Map<String, dynamic> map) {
    return EvaluasiModel(
      id: AFconvert.keInt(map['id']),
      klasi: AFconvert.keString(map['ev_klasi']),
      kode: AFconvert.keString(map['ev_kode']),
      kategori: AFconvert.keString(map['ev_kat']),
      tanya: AFconvert.keString(map['ev_tanya']),
      jenis: AFconvert.keString(map['ev_tanya_jns']),
      nilai: AFconvert.keString(map['ev_value']),
      nik: AFconvert.keString(map['ev_nik']),
      createdOn: AFconvert.keTanggal(map['created_on']),
    );
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'id': AFconvert.keString(id),
      'ev_klasi': klasi,
      'ev_kode': kode,
      'ev_kat': kategori,
      'ev_tanya': tanya,
      'ev_tanya_jns': jenis,
      'ev_value': nilai,
      'ev_nik': nik,
      'created_on': AFconvert.keString(createdOn),
    };
    return map;
  }
}

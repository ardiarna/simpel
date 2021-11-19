import 'package:simpel/utils/af_convert.dart';

class DiskusiModel {
  int id;
  String grup;
  String person;
  String isi;
  DateTime? tanggal;
  String url;
  String jenis;

  DiskusiModel({
    this.id = 0,
    this.grup = '',
    this.person = '',
    this.isi = '',
    this.tanggal,
    this.url = '',
    this.jenis = '',
  });

  factory DiskusiModel.dariMap(Map<String, dynamic> map) {
    return DiskusiModel(
      id: AFconvert.keInt(map['id']),
      grup: AFconvert.keString(map['grup']),
      person: AFconvert.keString(map['person']),
      isi: AFconvert.keString(map['isi']),
      tanggal: AFconvert.keTanggal(map['tanggal']),
      url: AFconvert.keString(map['url']),
      jenis: AFconvert.keString(map['jenis']),
    );
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'id': AFconvert.keString(id),
      'grup': grup,
      'person': person,
      'isi': isi,
      'tanggal': AFconvert.keString(tanggal),
      'url': url,
      'jenis': jenis,
    };
    return map;
  }
}

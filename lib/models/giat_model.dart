import 'package:simpel/utils/af_convert.dart';

class GiatModel {
  int id;
  String kode;
  String image;
  String singkatan;
  String nama;
  String desc;
  String permalink;

  GiatModel({
    this.id = 0,
    this.kode = '',
    this.image = '',
    this.singkatan = '',
    this.nama = '',
    this.desc = '',
    this.permalink = '',
  });

  factory GiatModel.dariMap(Map<String, dynamic> map) {
    return GiatModel(
      id: AFconvert.keInt(map['c_giat_id']),
      kode: AFconvert.keString(map['c_giat_kode']),
      image: AFconvert.keString(map['c_giat_gambar']),
      singkatan: AFconvert.keString(map['c_giat_singkatan']),
      nama: AFconvert.keString(map['c_giat_nama']),
      desc: AFconvert.keString(map['c_giat_desc']),
      permalink: AFconvert.keString(map['c_giat_permalink']),
    );
  }

  Map<String, dynamic> keMap() {
    Map<String, dynamic> map = {
      'c_giat_id': id,
      'c_giat_kode': kode,
      'c_giat_gambar': image,
      'c_giat_singkatan': singkatan,
      'c_giat_nama': nama,
      'c_giat_desc': desc,
      'c_giat_permalink': permalink,
    };
    return map;
  }
}

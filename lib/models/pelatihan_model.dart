import 'package:simpel/utils/af_convert.dart';

class PelatihanModel {
  String kode;
  String nama;
  String singkatan;
  int tahun;
  int angkatan;
  String fstatus;
  String fevaluasi;
  String fsurvey;
  String fileSertifikat;
  String giatKode;
  String giatImage;

  PelatihanModel({
    this.kode = '',
    this.nama = '',
    this.singkatan = '',
    this.tahun = 0,
    this.angkatan = 0,
    this.fstatus = '',
    this.fevaluasi = '',
    this.fsurvey = '',
    this.fileSertifikat = '',
    this.giatKode = '',
    this.giatImage = '',
  });

  factory PelatihanModel.dariMap(Map<String, dynamic> map) {
    return PelatihanModel(
      kode: AFconvert.keString(map['kode']),
      nama: AFconvert.keString(map['nama']),
      singkatan: AFconvert.keString(map['singkatan']),
      tahun: AFconvert.keInt(map['tahun']),
      angkatan: AFconvert.keInt(map['angkatan']),
      fstatus: AFconvert.keString(map['fstatus']),
      fevaluasi: AFconvert.keString(map['fevaluasi']),
      fsurvey: AFconvert.keString(map['fsurvey']),
      fileSertifikat: AFconvert.keString(map['file_sertifikat']),
      giatKode: AFconvert.keString(map['kd_giat']),
      giatImage: AFconvert.keString(map['image_giat']),
    );
  }

  Map<String, dynamic> keMap() {
    Map<String, dynamic> map = {
      'kode': kode,
      'nama': nama,
      'singkatan': singkatan,
      'tahun': tahun,
      'angkatan': angkatan,
      'fstatus': fstatus,
      'fevaluasi': fevaluasi,
      'fsurvey': fsurvey,
      'file_sertifikat': fileSertifikat,
      'kd_giat': giatKode,
      'image_giat': giatImage,
    };
    return map;
  }
}

class PersonPSMModel {
  String nik;
  String nama;
  String foto;
  String posisi;

  PersonPSMModel({
    this.nik = '',
    this.nama = '',
    this.foto = '',
    this.posisi = '',
  });

  factory PersonPSMModel.dariMap(Map<String, dynamic> map) {
    return PersonPSMModel(
      nik: AFconvert.keString(map['nik']),
      nama: AFconvert.keString(map['nama']),
      foto: AFconvert.keString(map['pas_foto']),
      posisi: AFconvert.keString(map['posisi']),
    );
  }

  Map<String, dynamic> keMap() {
    Map<String, dynamic> map = {
      'nik': nik,
      'nama': nama,
      'pas_foto': foto,
      'posisi': posisi,
    };
    return map;
  }
}

class PersonPesertaModel {
  String nik;
  String nama;
  String foto;
  String kedudukan;
  String bumdes;
  String provId;
  String provLabel;
  String kabId;
  String kabLabel;
  String kecId;
  String kecLabel;
  String kelId;
  String kelLabel;
  String dusun;

  PersonPesertaModel({
    this.nik = '',
    this.nama = '',
    this.foto = '',
    this.kedudukan = '',
    this.bumdes = '',
    this.provId = '',
    this.provLabel = '',
    this.kabId = '',
    this.kabLabel = '',
    this.kecId = '',
    this.kecLabel = '',
    this.kelId = '',
    this.kelLabel = '',
    this.dusun = '',
  });

  factory PersonPesertaModel.dariMap(Map<String, dynamic> map) {
    return PersonPesertaModel(
      nik: AFconvert.keString(map['nik']),
      nama: AFconvert.keString(map['nama']),
      foto: AFconvert.keString(map['pas_foto']),
      kedudukan: AFconvert.keString(map['kedudukan']),
      bumdes: AFconvert.keString(map['bumdes']),
      provId: AFconvert.keString(map['kd_prov']),
      kabId: AFconvert.keString(map['kd_kab']),
      kecId: AFconvert.keString(map['kd_kec']),
      kelId: AFconvert.keString(map['kd_kel']),
      provLabel: AFconvert.keString(map['kd_prov_label']),
      kabLabel: AFconvert.keString(map['kd_kab_label']),
      kecLabel: AFconvert.keString(map['kd_kec_label']),
      kelLabel: AFconvert.keString(map['kd_kel_label']),
      dusun: AFconvert.keString(map['dusun_rt_rw']),
    );
  }

  Map<String, dynamic> keMap() {
    Map<String, dynamic> map = {
      'nik': nik,
      'nama': nama,
      'pas_foto': foto,
      'kedudukan': kedudukan,
      'bumdes': bumdes,
      'kd_prov': provId,
      'kd_kab': kabId,
      'kd_kec': kecId,
      'kd_kel': kelId,
      'kd_prov_label': provLabel,
      'kd_kab_label': kabLabel,
      'kd_kec_label': kecLabel,
      'kd_kel_label': kelLabel,
      'dusun_rt_rw': dusun,
    };
    return map;
  }
}

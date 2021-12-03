import 'package:simpel/utils/af_convert.dart';

class RekrutmenModel {
  int id;
  String kdgiat;
  String nmgiat;
  String singkatangiat;
  String imagegiat;
  int tahun;
  int angkatan;
  DateTime? tglMulai;
  DateTime? tglSelesai;
  String provId;
  String provLabel;
  String kabId;
  String kabLabel;
  String kecId;
  String kecLabel;
  String kelId;
  String kelLabel;
  String dusun;
  String keterangan;
  String fstatus;
  String createdBy;
  String modifiedBy;
  DateTime? createdOn;
  DateTime? modifiedOn;
  String resume;

  RekrutmenModel({
    this.id = 0,
    this.kdgiat = '',
    this.nmgiat = '',
    this.singkatangiat = '',
    this.imagegiat = '',
    this.tahun = 0,
    this.angkatan = 0,
    this.tglMulai,
    this.tglSelesai,
    this.provId = '',
    this.provLabel = '',
    this.kabId = '',
    this.kabLabel = '',
    this.kecId = '',
    this.kecLabel = '',
    this.kelId = '',
    this.kelLabel = '',
    this.dusun = '',
    this.keterangan = '',
    this.fstatus = '',
    this.createdBy = '',
    this.modifiedBy = '',
    DateTime? createdOn,
    DateTime? modifiedOn,
    this.resume = '',
  });

  factory RekrutmenModel.dariMap(Map<String, dynamic> map) {
    return RekrutmenModel(
      id: AFconvert.keInt(map['id']),
      kdgiat: AFconvert.keString(map['kd_giat']),
      nmgiat: AFconvert.keString(map['nm_giat']),
      singkatangiat: AFconvert.keString(map['singkatan_giat']),
      imagegiat: AFconvert.keString(map['image_giat']),
      tahun: AFconvert.keInt(map['tahun']),
      angkatan: AFconvert.keInt(map['angkatan']),
      tglMulai: AFconvert.keTanggal(map['tgl_mulai']),
      tglSelesai: AFconvert.keTanggal(map['tgl_selesai']),
      provId: AFconvert.keString(map['kd_prov']),
      kabId: AFconvert.keString(map['kd_kab']),
      kecId: AFconvert.keString(map['kd_kec']),
      kelId: AFconvert.keString(map['kd_kel']),
      provLabel: AFconvert.keString(map['kd_prov_label']),
      kabLabel: AFconvert.keString(map['kd_kab_label']),
      kecLabel: AFconvert.keString(map['kd_kec_label']),
      kelLabel: AFconvert.keString(map['kd_kel_label']),
      dusun: AFconvert.keString(map['desa']),
      keterangan: AFconvert.keString(map['keterangan']),
      fstatus: AFconvert.keString(map['fstatus']),
      createdBy: AFconvert.keString(map['created_by']),
      modifiedBy: AFconvert.keString(map['modified_by']),
      createdOn: AFconvert.keTanggal(map['created_on']),
      modifiedOn: AFconvert.keTanggal(map['modified_on']),
      resume: AFconvert.keString(map['resume']),
    );
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'id': AFconvert.keString(id),
      'kd_giat': kdgiat,
      'nm_giat': nmgiat,
      'singkatan_giat': singkatangiat,
      'image_giat': singkatangiat,
      'tahun': AFconvert.keString(tahun),
      'angkatan': AFconvert.keString(angkatan),
      'tgl_mulai': AFconvert.keString(tglMulai),
      'tgl_selesai': AFconvert.keString(tglSelesai),
      'kd_prov': provId,
      'kd_kab': kabId,
      'kd_kec': kecId,
      'kd_kel': kelId,
      'desa': dusun,
      'keterangan': keterangan,
      'fstatus': fstatus,
      'created_by': createdBy,
      'modified_by': modifiedBy,
      'created_on': AFconvert.keString(createdOn),
      'modified_on': AFconvert.keString(modifiedOn),
      'resume': resume,
    };
    return map;
  }
}

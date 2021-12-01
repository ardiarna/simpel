import 'package:simpel/utils/af_convert.dart';

class MemberModel {
  String kategori;
  String nik;
  String nama;
  String email;
  String password;
  DateTime? tglLahir;
  String tmptLahir;
  String kelamin;
  String kelaminLabel;
  int agama;
  String agamaLabel;
  int kawin;
  String kawinLabel;
  String pekerjaan;
  String pendidikan;
  String pendidikanLabel;
  String jurusan;
  String phone;
  String provId;
  String provLabel;
  String kabId;
  String kabLabel;
  String kecId;
  String kecLabel;
  String kelId;
  String kelLabel;
  String dusun;
  String foto;
  String ktp;
  String keterangan;
  int flagEmail;
  DateTime? tglLastLogin;
  String fstatus;
  String ipLogin;
  String token;
  DateTime? createdOn;
  DateTime? modifiedOn;
  String modifiedBy;
  String instansi;
  String instansiLabel;
  String posisi;
  String posisiLabel;
  String inteks;

  MemberModel({
    this.kategori = '',
    this.nik = '',
    this.nama = '',
    this.email = '',
    this.password = '',
    this.tglLahir,
    this.tmptLahir = '',
    this.kelamin = '',
    this.kelaminLabel = '',
    this.agama = 0,
    this.agamaLabel = '',
    this.kawin = 0,
    this.kawinLabel = '',
    this.pekerjaan = '',
    this.pendidikan = '',
    this.pendidikanLabel = '',
    this.jurusan = '',
    this.phone = '',
    this.provId = '',
    this.provLabel = '',
    this.kabId = '',
    this.kabLabel = '',
    this.kecId = '',
    this.kecLabel = '',
    this.kelId = '',
    this.kelLabel = '',
    this.dusun = '',
    this.foto = '',
    this.ktp = '',
    this.keterangan = '',
    this.flagEmail = 0,
    this.tglLastLogin,
    this.fstatus = '',
    this.ipLogin = '',
    this.token = '',
    this.createdOn,
    this.modifiedOn,
    this.modifiedBy = '',
    this.instansi = '',
    this.instansiLabel = '',
    this.posisi = '',
    this.posisiLabel = '',
    this.inteks = '',
  });

  factory MemberModel.dariMap(Map<String, dynamic> map) {
    return MemberModel(
      kategori: AFconvert.keString(map['kategori']),
      nik: AFconvert.keString(map['nik']),
      nama: AFconvert.keString(map['nama']),
      email: AFconvert.keString(map['email']),
      password: AFconvert.keString(map['password']),
      tglLahir: AFconvert.keTanggal(map['tgl_lahir']),
      tmptLahir: AFconvert.keString(map['tmpt_lahir']),
      kelamin: AFconvert.keString(map['jns_kelamin']),
      kelaminLabel: AFconvert.keString(map['jns_kelamin_label']),
      agama: AFconvert.keInt(map['agama']),
      agamaLabel: AFconvert.keString(map['agama_label']),
      kawin: AFconvert.keInt(map['status_kawin']),
      kawinLabel: AFconvert.keString(map['status_kawin_label']),
      pekerjaan: AFconvert.keString(map['pekerjaan']),
      pendidikan: AFconvert.keString(map['pendidikan']),
      pendidikanLabel: AFconvert.keString(map['pendidikan_label']),
      jurusan: AFconvert.keString(map['jurusan']),
      phone: AFconvert.keString(map['no_hp']),
      provId: AFconvert.keString(map['kd_prov']),
      kabId: AFconvert.keString(map['kd_kab']),
      kecId: AFconvert.keString(map['kd_kec']),
      kelId: AFconvert.keString(map['kd_kel']),
      provLabel: AFconvert.keString(map['kd_prov_label']),
      kabLabel: AFconvert.keString(map['kd_kab_label']),
      kecLabel: AFconvert.keString(map['kd_kec_label']),
      kelLabel: AFconvert.keString(map['kd_kel_label']),
      dusun: AFconvert.keString(map['dusun_rt_rw']),
      foto: AFconvert.keString(map['pas_foto']),
      ktp: AFconvert.keString(map['ktp']),
      keterangan: AFconvert.keString(map['keterangan']),
      flagEmail: AFconvert.keInt(map['flag_email']),
      tglLastLogin: AFconvert.keTanggal(map['last_login']),
      fstatus: AFconvert.keString(map['fstatus']),
      ipLogin: AFconvert.keString(map['ip_login']),
      token: AFconvert.keString(map['token']),
      createdOn: AFconvert.keTanggal(map['created_on']),
      modifiedOn: AFconvert.keTanggal(map['modified_on']),
      modifiedBy: AFconvert.keString(map['modified_by']),
      instansi: AFconvert.keString(map['kd_ins']),
      posisi: AFconvert.keString(map['posisi']),
      inteks: AFconvert.keString(map['int_eks']),
      instansiLabel: AFconvert.keString(map['kd_ins_label']),
      posisiLabel: AFconvert.keString(map['posisi_label']),
    );
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'nik': nik,
      'nama': nama,
      'email': email,
      'password': password,
      'tgl_lahir': AFconvert.keString(tglLahir),
      'tmpt_lahir': tmptLahir,
      'jns_kelamin': kelamin,
      'agama': AFconvert.keString(agama),
      'status_kawin': AFconvert.keString(kawin),
      'pekerjaan': pekerjaan,
      'pendidikan': pendidikan,
      'jurusan': jurusan,
      'no_hp': phone,
      'kd_prov': provId,
      'kd_kab': kabId,
      'kd_kec': kecId,
      'kd_kel': kelId,
      'dusun_rt_rw': dusun,
      'pas_foto': foto,
      'ktp': ktp,
      'keterangan': keterangan,
      'flag_email': AFconvert.keString(flagEmail),
      'last_login': AFconvert.keString(tglLastLogin),
      'fstatus': fstatus,
      'ip_login': ipLogin,
      'token': token,
      'created_on': AFconvert.keString(createdOn),
      'modified_on': AFconvert.keString(modifiedOn),
      'modified_by': modifiedBy,
      'kd_ins': instansi,
      'posisi': posisi,
      'int_eks': inteks,
    };
    return map;
  }
}

import 'package:simpel/models/bumdes_model.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/models/rekrutmen_model.dart';
import 'package:simpel/utils/db_helper.dart';

class RekrutmenBloc {
  Future<List<RekrutmenModel>> getRekrutmens() async {
    List<RekrutmenModel> list = [];
    var a = await DBHelper.getDaftar(
      rute: 'rekrutmen',
      mode: 'get',
    );
    for (var el in a) {
      var b = RekrutmenModel.dariMap(el);
      list.add(b);
    }
    return list;
  }

  Future<RekrutmenModel> getRekrutmenId(String kode) async {
    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'rekrutmen',
      mode: 'get',
      body: {'kode': kode},
    );
    return a != null ? RekrutmenModel.dariMap(a) : RekrutmenModel();
  }

  Future<Map<String, dynamic>> cekDaftar(String nik, String kdgiat) async {
    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'rekrutmen',
      mode: 'cek',
      body: {'nik': nik, 'kd_giat': kdgiat},
    );
    Map<String, dynamic> b = {};
    if (a != null) {
      b = a;
      b["sudah_daftar"] = "Y";
    } else {
      b["sudah_daftar"] = "N";
    }
    return b;
  }

  Future<Map<String, dynamic>> add({
    required MemberModel member,
    required BumdesModel bumdes,
    required RekrutmenModel rekrutmen,
  }) async {
    var a = await DBHelper.setData(
      rute: 'rekrutmen',
      mode: 'add',
      body: {
        'kd_giat': rekrutmen.kdgiat,
        'tahun': rekrutmen.tahun.toString(),
        'angkatan': rekrutmen.angkatan.toString(),
        'nik': member.nik,
        'kd_prov': member.provId,
        'kd_kab': member.kabId,
        'kd_kec': member.kecId,
        'kd_kel': member.kelId,
        'alamat': member.dusun,
        'nama_bumdes': bumdes.nama,
        'tahun_bumdes': bumdes.tahun.toString(),
        'unitusaha_bumdes': bumdes.unitusaha,
        'omzet_bumdes': bumdes.omset,
        'jab_desa_bumdes': bumdes.jabatan,
        'jab_periode': bumdes.jabperiode,
        'kendala_bumdes': bumdes.kendala,
      },
    );
    return a;
  }
}

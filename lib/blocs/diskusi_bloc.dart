import 'package:simpel/models/diskusi_model.dart';
import 'package:simpel/models/giat_model.dart';
import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/utils/db_helper.dart';

class DiskusiBloc {
  final String _dirImage = DBHelper.dirImage;
  String get dirImage => _dirImage;

  final String _dirImageGiat = DBHelper.dirImage + 'pelatihan/mobile/';
  String get dirImageGiat => _dirImageGiat;

  Future<List<DiskusiModel>> getDiskusis(String grup) async {
    List<DiskusiModel> list = [];
    var a = await DBHelper.getDaftar(
      methodeRequest: MethodeRequest.post,
      rute: 'diskusi',
      mode: 'get',
      body: {'grup': grup},
    );
    for (var el in a) {
      var b = DiskusiModel.dariMap(el);
      list.add(b);
    }
    return list;
  }

  Future<List<PelatihanModel>> getPelatihans(String nik) async {
    List<PelatihanModel> list = [];
    var a = await DBHelper.getDaftar(
      methodeRequest: MethodeRequest.post,
      rute: 'pelatihan',
      mode: 'get',
      body: {'nik': nik},
    );
    for (var el in a) {
      var b = PelatihanModel.dariMap(el);
      list.add(b);
    }
    return list;
  }

  Future<GiatModel> getGiatId(String kode) async {
    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'combo',
      mode: 'giat',
      body: {'kode': kode},
    );
    return a != null ? GiatModel.dariMap(a) : GiatModel();
  }
}

import 'package:simpel/models/bumdes_model.dart';
import 'package:simpel/utils/db_helper.dart';

class BumdesBloc {
  Future<BumdesModel> get(String nik) async {
    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'bumdes',
      mode: 'get',
      body: {'nik': nik},
    );
    return a != null ? BumdesModel.dariMap(a) : BumdesModel();
  }

  Future<Map<String, dynamic>> edit(BumdesModel mod) async {
    var map = mod.keMap();
    var a = await DBHelper.setData(
      rute: 'bumdes',
      mode: 'edit',
      body: map,
    );
    return a;
  }

  Future<KedudukanModel> getKedudukan(String nik) async {
    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'bumdes',
      mode: 'getkedudukan',
      body: {'nik': nik},
    );
    return a != null ? KedudukanModel.dariMap(a) : KedudukanModel();
  }

  Future<Map<String, dynamic>> editKedudukan(KedudukanModel mod) async {
    var map = mod.keMap();
    var a = await DBHelper.setData(
      rute: 'bumdes',
      mode: 'editkedudukan',
      body: map,
    );
    return a;
  }
}

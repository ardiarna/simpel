import 'package:simpel/blocs/member_bloc.dart';
import 'package:simpel/models/member_model.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class AFcache {
  Future setUser(String kategori, String id) async {
    final _pref = await StreamingSharedPreferences.instance;
    _pref.setString('kategori', kategori);
    _pref.setString('id', id);
  }

  Future<String?> cekUserId() async {
    final _pref = await StreamingSharedPreferences.instance;
    var id = _pref.getString('id', defaultValue: '').getValue();
    return id == '' ? null : id;
  }

  Future<MemberModel> getUser() async {
    final _pref = await StreamingSharedPreferences.instance;
    final MemberBloc _memberBloc = MemberBloc();
    String kategori = _pref.getString('kategori', defaultValue: '').getValue();
    String id = _pref.getString('id', defaultValue: '').getValue();

    var a = await _memberBloc.getMember(kategori, id);
    return a;
  }

  Future removeUser() async {
    final _pref = await StreamingSharedPreferences.instance;
    _pref.remove('kategori');
    _pref.remove('id');
  }

  Future clear() async {
    final _pref = await StreamingSharedPreferences.instance;
    _pref.clear();
  }
}

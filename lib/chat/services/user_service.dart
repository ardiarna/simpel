import 'package:simpel/chat/models/user_model.dart';
import 'package:simpel/chat/services/user_service_contract.dart';
import 'package:simpel/utils/af_convert.dart';
import 'package:simpel/utils/db_helper.dart';

class UserService implements IUserService {
  @override
  Future<User> create(User user) async {
    var data = user.keMap();
    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'chat',
      mode: 'adduser',
      body: data,
    );

    return a != null ? User.dariMap(a) : User();
  }

  @override
  Future<User> connect(User user) async {
    var data = user.keMap();
    if (user.idn != '') data['id'] = user.idn;

    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'chat',
      mode: 'connect',
      body: data,
    );

    return a != null ? User.dariMap(a) : User();
  }

  @override
  Future<void> disconnect(String nik, DateTime lastseen) async {
    String last = AFconvert.keString(lastseen);
    await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'chat',
      mode: 'disconnect',
      body: {'nik': nik, 'last_seen': last},
    );
  }

  @override
  Future<List<User>> online() async {
    List<User> list = [];
    var a = await DBHelper.getDaftar(
      methodeRequest: MethodeRequest.post,
      rute: 'chat',
      mode: 'online',
      body: {'active': 'Y'},
    );
    for (var el in a) {
      var b = User.dariMap(el);
      list.add(b);
    }
    return list;
  }

  @override
  Future<List<User>> fetch(List<String> niks) async {
    List<User> list = [];
    for (var nik in niks) {
      var a = await DBHelper.getData(
        methodeRequest: MethodeRequest.post,
        rute: 'chat',
        mode: 'getuser',
        body: {'nik': nik},
      );
      var b = a != null ? User.dariMap(a) : User();
      list.add(b);
    }
    return list;
  }
}

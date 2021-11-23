import 'package:bloc/bloc.dart';
import 'package:simpel/chat/blocs/user_state.dart';
import 'package:simpel/chat/local_cache.dart';
import 'package:simpel/chat/models/user_model.dart';
import 'package:simpel/chat/services/user_service_contract.dart';

class UserCubit extends Cubit<UserState> {
  final IUserService _userService;
  final ILocalCache _localCache;

  UserCubit(this._userService, this._localCache) : super(UserInitial());

  Future<User> connect(String nik, String username, String photoUrl) async {
    emit(Loading());
    final user = User(
      nik: nik,
      username: username,
      photoUrl: photoUrl,
      active: true,
      lastseen: DateTime.now(),
    );
    final createdUser = await _userService.connect(user);
    final userJson = {
      'nik': createdUser.nik,
      'username': createdUser.username,
      'active': true,
      'photo_url': createdUser.photoUrl,
      'id': createdUser.idn,
    };
    final userCache = _localCache.fetch('USER');
    if (userCache.isEmpty) await _localCache.save('USER', userJson);
    emit(UserSuccess(createdUser));
    return createdUser;
  }
}

import 'package:bloc/bloc.dart';
import 'package:simpel/chat/blocs/diskusi_state.dart';
import 'package:simpel/chat/models/user_model.dart';
import 'package:simpel/chat/services/user_service_contract.dart';

class DiskusiCubit extends Cubit<DiskusiState> {
  IUserService _userService;

  DiskusiCubit(this._userService) : super(DiskusiInitial());

  Future<void> activeUsers(User user) async {
    emit(DiskusiLoading());
    final users = await _userService.online();
    users.removeWhere((ele) => ele.idn == user.idn);
    emit(DiskusiSuccess(users));
  }
}

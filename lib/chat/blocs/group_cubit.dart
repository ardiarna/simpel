import 'package:bloc/bloc.dart';
import 'package:simpel/chat/models/user_model.dart';

class GroupCubit extends Cubit<List<User>> {
  GroupCubit() : super([]);

  add(User user) {
    state.add(user);
    emit(List.from(state));
  }

  remove(User user) {
    state.removeWhere((ele) => ele.nik == user.nik);
    emit(List.from(state));
  }
}

import 'package:equatable/equatable.dart';
import 'package:simpel/chat/models/user_model.dart';

abstract class UserState extends Equatable {}

class UserInitial extends UserState {
  @override
  List<Object?> get props => [];
}

class Loading extends UserState {
  @override
  List<Object?> get props => [];
}

class UserSuccess extends UserState {
  final User user;

  UserSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

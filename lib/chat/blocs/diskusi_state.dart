import 'package:equatable/equatable.dart';
import 'package:simpel/chat/models/user_model.dart';

abstract class DiskusiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DiskusiInitial extends DiskusiState {
  @override
  List<Object?> get props => [];
}

class DiskusiLoading extends DiskusiState {
  @override
  List<Object?> get props => [];
}

class DiskusiSuccess extends DiskusiState {
  final List<User> onlineUsers;
  DiskusiSuccess(this.onlineUsers);

  @override
  List<Object?> get props => [onlineUsers];
}

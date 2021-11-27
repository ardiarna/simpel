import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:simpel/chat/models/message_group_model.dart';
import 'package:simpel/chat/services/group_service.dart';
import 'package:equatable/equatable.dart';
import 'package:simpel/chat/models/user_model.dart';

part 'message_group_event.dart';
part 'message_group_state.dart';

class MessageGroupBloc extends Bloc<MessageGroupEvent, MessageGroupState> {
  final IGroupService _groupService;
  StreamSubscription? _subscription;

  MessageGroupBloc(this._groupService) : super(MessageGroupState.initial()) {
    on<Subscribed>(_onSubcribed);
    on<_MessageGroupReceived>(_onMessageGroupReceived);
    on<MessageGroupCreated>(_onMessageGroupCreated);
  }

  void _onSubcribed(Subscribed event, Emitter<MessageGroupState> emit) async {
    // await _subscription.cancel();
    _subscription = _groupService
        .groups(me: event.user)
        .listen((messageGroup) => add(_MessageGroupReceived(messageGroup)));
  }

  void _onMessageGroupReceived(
      _MessageGroupReceived event, Emitter<MessageGroupState> emit) {
    emit(MessageGroupState.received(event.messageGroup));
  }

  void _onMessageGroupCreated(
      MessageGroupCreated event, Emitter<MessageGroupState> emit) async {
    final messageGroup = await _groupService.create(event.messageGroup);
    emit(MessageGroupState.created(messageGroup));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _groupService.dispose();
    return super.close();
  }
}

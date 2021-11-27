import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:simpel/chat/models/typing_event_model.dart';
import 'package:equatable/equatable.dart';
import 'package:simpel/chat/models/user_model.dart';
import 'package:simpel/chat/services/typing_service_contract.dart';

part 'typing_event.dart';
part 'typing_state.dart';

class TypingNotificationBloc
    extends Bloc<TypingNotificationEvent, TypingNotificationState> {
  final ITypingNotification _typingNotification;
  StreamSubscription? _subscription;

  TypingNotificationBloc(this._typingNotification)
      : super(TypingNotificationState.initial()) {
    on<Subscribed>(_onSubscribed);
    on<_TypingNotificationReceived>(_onTypingNotificationReceived);
    on<TypingNotificationSent>(_onTypingNotificationSent);
    on<NotSubscribed>(_onNotSubscribed);
  }

  _onSubscribed(Subscribed event, Emitter<TypingNotificationState> emit) async {
    if (event.usersWithChat == null) {
      add(NotSubscribed());
      return;
    }
    // await _subscription.cancel();
    _subscription = _typingNotification
        .subscribe(event.user, event.usersWithChat!)
        .listen((ev) => add(_TypingNotificationReceived(ev)));
  }

  _onTypingNotificationReceived(_TypingNotificationReceived event,
      Emitter<TypingNotificationState> emit) {
    emit(TypingNotificationState.received(event.event));
  }

  _onTypingNotificationSent(TypingNotificationSent event,
      Emitter<TypingNotificationState> emit) async {
    await _typingNotification.send(events: event.events);
    emit(TypingNotificationState.sent());
  }

  _onNotSubscribed(NotSubscribed event, Emitter<TypingNotificationState> emit) {
    emit(TypingNotificationState.initial());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _typingNotification.dispose();
    return super.close();
  }
}

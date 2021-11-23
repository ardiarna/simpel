import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:simpel/chat/services/receipt_service_contract.dart';
import 'package:equatable/equatable.dart';
import 'package:simpel/chat/models/receipt_model.dart';
import 'package:simpel/chat/models/user_model.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final IReceiptService _receiptService;
  StreamSubscription? _subscription;

  ReceiptBloc(this._receiptService) : super(ReceiptState.initial()) {
    on<Subscribed>(_onSubscribed);
    on<_ReceiptReceived>(_onReceiptReceived);
    on<ReceiptSent>(_onReceiptSent);
  }

  _onSubscribed(Subscribed event, Emitter<ReceiptState> emit) async {
    await _subscription?.cancel();
    _subscription = _receiptService
        .receipts(event.user)
        .listen((receipt) => add(_ReceiptReceived(receipt)));
  }

  _onReceiptReceived(_ReceiptReceived event, Emitter<ReceiptState> emit) {
    emit(ReceiptState.received(event.receipt));
  }

  _onReceiptSent(ReceiptSent event, Emitter<ReceiptState> emit) async {
    await _receiptService.send(event.receipt);
    emit(ReceiptState.sent(event.receipt));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _receiptService.dispose();
    return super.close();
  }
}

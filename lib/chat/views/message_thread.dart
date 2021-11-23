import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simpel/chat/blocs/chats_cubit.dart';
import 'package:simpel/chat/blocs/message/message_bloc.dart';
import 'package:simpel/chat/blocs/message_thread/message_thread_cubit.dart';
import 'package:simpel/chat/blocs/receipt/receipt_bloc.dart';
import 'package:simpel/chat/blocs/typing/typing_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpel/chat/models/message_model.dart';
import 'package:simpel/chat/models/typing_event_model.dart';
import 'package:simpel/chat/views/header_status.dart';
import 'package:simpel/chat/models/local_message_model.dart';
import 'package:simpel/chat/models/receipt_model.dart';
import 'package:simpel/chat/views/receiver_message.dart';
import 'package:simpel/chat/views/sender_message.dart';
import 'package:simpel/utils/db_helper.dart';

import '../models/user_model.dart';

class MessageThread extends StatefulWidget {
  final User receiver;
  final User me;
  final String chatId;
  final MessageBloc messageBloc;
  final TypingNotificationBloc typingNotificationBloc;
  final ChatsCubit chatsCubit;

  const MessageThread(
    this.receiver,
    this.me,
    this.messageBloc,
    this.chatsCubit,
    this.typingNotificationBloc, {
    String chatId = '',
  }) : this.chatId = chatId;

  @override
  _MessageThreadState createState() => _MessageThreadState();
}

class _MessageThreadState extends State<MessageThread> {
  final String _dirImageMember = DBHelper.dirImage + 'member/';

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _txt = TextEditingController();
  String chatId = '';
  late User receiver;
  StreamSubscription? _subscription;
  List<LocalMessage> messages = [];
  Timer? _startTypingTimer;
  Timer? _stopTypingTimer;

  @override
  void initState() {
    super.initState();
    chatId = widget.chatId;
    receiver = widget.receiver;
    _updateOnMessageReceived();
    _updateOnReceiptReceived();
    context.read<ReceiptBloc>().add(ReceiptEvent.onSubscribed(widget.me));
    widget.typingNotificationBloc.add(
      TypingNotificationEvent.onSubscribed(widget.me,
          usersWithChat: [receiver.nik]),
    );
  }

  @override
  void dispose() {
    _txt.dispose();
    _subscription?.cancel();
    _stopTypingTimer?.cancel();
    _startTypingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            Expanded(
              child:
                  BlocBuilder<TypingNotificationBloc, TypingNotificationState>(
                bloc: widget.typingNotificationBloc,
                builder: (_, state) {
                  bool typing = false;
                  if (state is TypingNotificationReceivedSuccess &&
                      state.event.event == Typing.start &&
                      state.event.from == receiver.nik) {
                    typing = true;
                  }

                  return HeaderStatus(
                    receiver.username,
                    receiver.photoUrl != ''
                        ? _dirImageMember + receiver.photoUrl
                        : '',
                    receiver.active,
                    lastSeen: receiver.lastseen,
                    typing: typing,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            Flexible(
              flex: 6,
              child: BlocBuilder<MessageThreadCubit, List<LocalMessage>>(
                builder: (_, messages) {
                  this.messages = messages;
                  if (this.messages.isEmpty)
                    return Container(
                      color: Colors.transparent,
                    );
                  WidgetsBinding.instance
                      ?.addPostFrameCallback((_) => _scrollToEnd());
                  return _buildListOfMessages();
                },
              ),
            ),
            Expanded(
              child: Container(
                height: 199,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 13),
                      blurRadius: 6,
                      color: Colors.black12,
                    ),
                  ],
                ),
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _buildMessageInput(context),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Container(
                          height: 45,
                          width: 45,
                          child: RawMaterialButton(
                              fillColor: Colors.green,
                              shape: CircleBorder(),
                              elevation: 5,
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _sendMessage();
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildListOfMessages() => ListView.builder(
        itemCount: messages.length,
        padding: EdgeInsets.fromLTRB(16, 16, 0, 20),
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        addAutomaticKeepAlives: true,
        itemBuilder: (_, i) {
          if (messages[i].message.from == receiver.nik) {
            _sendReceipt(messages[i]);
            return Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: ReceiverMessage(
                  messages[i],
                  receiver.photoUrl != ''
                      ? _dirImageMember + receiver.photoUrl
                      : ''),
            );
          } else {
            return Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: SenderMessage(messages[i]),
            );
          }
        },
      );

  _buildMessageInput(BuildContext context) {
    final _border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(90)),
      borderSide: BorderSide.none,
    );
    return Focus(
      onFocusChange: (focus) {
        if (_startTypingTimer == null || (_startTypingTimer != null && focus))
          return;
        _stopTypingTimer?.cancel();
        _dispatchTyping(Typing.stop);
      },
      child: TextFormField(
        controller: _txt,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: Theme.of(context).textTheme.caption,
        onChanged: _sendTypingNotification,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
          enabledBorder: _border,
          filled: true,
          focusedBorder: _border,
        ),
      ),
    );
  }

  void _updateOnMessageReceived() {
    final messageThreadCubit = context.read<MessageThreadCubit>();
    if (chatId.isNotEmpty) messageThreadCubit.messages(chatId);
    _subscription = widget.messageBloc.stream.listen((state) async {
      if (state is MessageReceivedSuccess) {
        await messageThreadCubit.viewModel.receivedMessage(state.message);
        final receipt = Receipt(
          recipient: state.message.from,
          messageId: state.message.id,
          status: ReceiptStatus.read,
          timestamp: DateTime.now(),
        );
        context.read<ReceiptBloc>().add(ReceiptEvent.onReceiptSent(receipt));
      }
      if (state is MessageSentSuccess) {
        await messageThreadCubit.viewModel.sentMessage(state.message);
      }
      if (chatId.isEmpty) chatId = messageThreadCubit.viewModel.chatId;
      messageThreadCubit.messages(chatId);
    });
  }

  void _updateOnReceiptReceived() {
    final messageThreadCubit = context.read<MessageThreadCubit>();
    context.read<ReceiptBloc>().stream.listen((state) async {
      if (state is ReceiptReceivedSuccess) {
        await messageThreadCubit.viewModel.updateMessageReceipt(state.receipt);
        messageThreadCubit.messages(chatId);
        widget.chatsCubit.chats();
      }
    });
  }

  _sendMessage() {
    if (_txt.text.trim().isEmpty) return;

    final message = Message(
      from: widget.me.nik,
      to: receiver.nik,
      timestamp: DateTime.now(),
      contents: _txt.text,
    );

    final sendMessageEvent = MessageEvent.onMessageSent(message);
    widget.messageBloc.add(sendMessageEvent);

    _txt.clear();
    _startTypingTimer?.cancel();
    _stopTypingTimer?.cancel();

    _dispatchTyping(Typing.stop);
  }

  _sendReceipt(LocalMessage message) async {
    if (message.receipt == ReceiptStatus.read) return;
    final receipt = Receipt(
      recipient: message.message.from,
      messageId: message.id,
      status: ReceiptStatus.read,
      timestamp: DateTime.now(),
    );
    context.read<ReceiptBloc>().add(ReceiptEvent.onReceiptSent(receipt));
    await context
        .read<MessageThreadCubit>()
        .viewModel
        .updateMessageReceipt(receipt);
  }

  void _dispatchTyping(Typing event) {
    final typing =
        TypingEvent(from: widget.me.nik, to: receiver.nik, event: event);
    widget.typingNotificationBloc
        .add(TypingNotificationEvent.onTypingEventSent(typing));
  }

  void _sendTypingNotification(String text) {
    if (text.trim().isEmpty || messages.isEmpty) return;
    if (_startTypingTimer?.isActive ?? false) return;
    if (_stopTypingTimer?.isActive ?? false) _stopTypingTimer?.cancel();
    _dispatchTyping(Typing.start);
    _startTypingTimer = Timer(Duration(seconds: 5), () {});
    _stopTypingTimer =
        Timer(Duration(seconds: 6), () => _dispatchTyping(Typing.stop));
  }

  _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(microseconds: 200),
      curve: Curves.easeInOut,
    );
  }
}

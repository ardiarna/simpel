import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simpel/chat/blocs/chats_cubit.dart';
import 'package:simpel/chat/blocs/message/message_bloc.dart';
import 'package:simpel/chat/blocs/message_thread/message_thread_cubit.dart';
import 'package:simpel/chat/blocs/receipt/receipt_bloc.dart';
import 'package:simpel/chat/blocs/typing/typing_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpel/chat/models/chat_model.dart';
import 'package:simpel/chat/models/message_model.dart';
import 'package:simpel/chat/models/typing_event_model.dart';
import 'package:simpel/chat/views/header_status.dart';
import 'package:simpel/chat/models/local_message_model.dart';
import 'package:simpel/chat/models/receipt_model.dart';
import 'package:simpel/chat/views/receiver_message.dart';
import 'package:simpel/chat/views/sender_message.dart';
import 'package:simpel/utils/af_convert.dart';
import 'package:simpel/utils/db_helper.dart';

import '../models/user_model.dart';

class MessageThread extends StatefulWidget {
  final List<User> receivers;
  final User me;
  final Chat chat;
  final TypingNotificationBloc typingNotificationBloc;
  final ChatsCubit chatsCubit;

  const MessageThread(
    this.receivers,
    this.me,
    this.chatsCubit,
    this.typingNotificationBloc,
    this.chat,
  );

  @override
  _MessageThreadState createState() => _MessageThreadState();
}

class _MessageThreadState extends State<MessageThread> {
  final String _dirImageMember = DBHelper.dirImage + 'member/';
  final String _dirImageGiat = DBHelper.dirImage + 'pelatihan/mobile/';
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _txt = TextEditingController();
  String chatId = '';
  List<User> receivers = [];
  StreamSubscription? _subscription;
  List<LocalMessage> messages = [];
  Timer? _startTypingTimer;
  Timer? _stopTypingTimer;

  void _updateOnMessageReceived() {
    final messageThreadCubit = context.read<MessageThreadCubit>();
    if (chatId != '') messageThreadCubit.messages(chatId);
    context.read<MessageBloc>().add(MessageEvent.onSubscribed(widget.me));
    _subscription = context.read<MessageBloc>().stream.listen((state) async {
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
        widget.chatsCubit.chats();
      }
      if (chatId == '') chatId = messageThreadCubit.viewModel.chatId;
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

  @override
  void initState() {
    super.initState();
    chatId = widget.chat.id;
    receivers = widget.receivers;
    receivers.removeWhere((e) => e.nik == widget.me.nik);
    _updateOnMessageReceived();
    _updateOnReceiptReceived();
    context.read<ReceiptBloc>().add(ReceiptEvent.onSubscribed(widget.me));
    widget.typingNotificationBloc.add(
      TypingNotificationEvent.onSubscribed(
        widget.me,
        usersWithChat: receivers.map((e) => e.nik).toList(),
      ),
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
                  String typing = '';
                  if (state is TypingNotificationReceivedSuccess &&
                      state.event.event == Typing.start &&
                      state.event.chatId == chatId) {
                    if (widget.chat.type == ChatType.individual)
                      typing = 'Mengetik...';
                    else
                      typing =
                          '${receivers.firstWhere((e) => e.nik == state.event.from).username} mengetik...';
                  }

                  return HeaderStatus(
                    widget.chat.name != ''
                        ? widget.chat.name
                        : receivers.first.username,
                    widget.chat.type == ChatType.individual
                        ? receivers.first.photoUrl != ''
                            ? _dirImageMember + receivers.first.photoUrl
                            : ''
                        : widget.chat.photoUrl != ''
                            ? _dirImageGiat + widget.chat.photoUrl
                            : '',
                    widget.chat.type == ChatType.individual
                        ? receivers.first.active
                        : false,
                    description: widget.chat.type == ChatType.individual
                        ? 'terakhir terlihat ${AFconvert.matDateTime(receivers.first.lastseen)}'
                        : receivers
                            .fold<String>('', (p, e) => p + ', ' + e.username)
                            .replaceFirst(',', '')
                            .trim(),
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
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: BlocBuilder<MessageThreadCubit, List<LocalMessage>>(
                builder: (_, messages) {
                  this.messages = messages;
                  if (this.messages.isEmpty)
                    return Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(top: 30),
                      color: Colors.transparent,
                      child: widget.chat.type == ChatType.group
                          ? DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: Text(
                                  'Grup dibuat',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            )
                          : Container(),
                    );
                  WidgetsBinding.instance
                      ?.addPostFrameCallback((_) => _scrollToEnd());
                  return _buildListOfMessages();
                },
              ),
            ),
            Container(
              constraints: BoxConstraints(
                minHeight: 70,
                maxHeight: 70,
              ),
              height: 70,
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
                        height: 35,
                        width: 35,
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
          ],
        ),
      ),
    );
  }

  _buildListOfMessages() => ListView.builder(
        itemCount: messages.length,
        padding: EdgeInsets.fromLTRB(0, 16, 0, 20),
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        addAutomaticKeepAlives: true,
        itemBuilder: (_, i) {
          if (receivers.any((e) => e.nik == messages[i].message.from)) {
            _sendReceipt(messages[i]);
            final receiver =
                receivers.firstWhere((e) => e.nik == messages[i].message.from);
            final String color = widget.chat.membersId
                .firstWhere((e) => e.containsKey(receiver.nik))
                .values
                .first;
            return Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: ReceiverMessage(
                messages[i],
                receiver,
                widget.chat.type,
                color: ChatType.group == widget.chat.type
                    ? Color(int.parse(color))
                    : null,
              ),
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

  _sendMessage() {
    if (_txt.text.trim().isEmpty) return;

    final messages = receivers
        .map((e) => Message(
              groupId:
                  widget.chat.type == ChatType.group ? widget.chat.id : null,
              from: widget.me.nik,
              to: e.nik,
              timestamp: DateTime.now(),
              contents: _txt.text,
            ))
        .toList();
    final sendMessageEvent = MessageEvent.onMessageSent(messages);
    context.read<MessageBloc>().add(sendMessageEvent);

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
    if (widget.chat.type == ChatType.individual)
      context.read<ReceiptBloc>().add(ReceiptEvent.onReceiptSent(receipt));
    await context
        .read<MessageThreadCubit>()
        .viewModel
        .updateMessageReceipt(receipt);
  }

  void _dispatchTyping(Typing event) {
    final chatid = widget.chat.type == ChatType.group ? chatId : widget.me.nik;
    final typings = receivers
        .map((e) => TypingEvent(
            from: widget.me.nik, to: e.nik, event: event, chatId: chatid))
        .toList();
    widget.typingNotificationBloc
        .add(TypingNotificationEvent.onTypingEventSent(typings));
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

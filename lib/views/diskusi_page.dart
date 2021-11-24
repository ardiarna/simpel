import 'package:flutter/material.dart';
import 'package:simpel/blocs/diskusi_bloc.dart';
import 'package:simpel/chat/blocs/chats_cubit.dart';
import 'package:simpel/chat/blocs/diskusi_cubit.dart';
import 'package:simpel/chat/blocs/message/message_bloc.dart';
import 'package:simpel/chat/blocs/typing/typing_bloc.dart';
import 'package:simpel/chat/diskusi_route.dart';
import 'package:simpel/chat/models/chat_model.dart';
import 'package:simpel/chat/models/typing_event_model.dart';
import 'package:simpel/chat/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/utils/af_convert.dart';
import 'package:simpel/utils/af_widget.dart';

class DiskusiPage extends StatefulWidget {
  final MemberModel member;
  final User user;
  final IDiskusiRouter router;
  const DiskusiPage(
      {required this.member,
      required this.user,
      required this.router,
      Key? key})
      : super(key: key);

  @override
  _DiskusiPageState createState() => _DiskusiPageState();
}

class _DiskusiPageState extends State<DiskusiPage> {
  final DiskusiBloc _diskusiBloc = DiskusiBloc();
  List<Chat> chats = [];
  final typingEvents = [];

  @override
  void initState() {
    super.initState();
    if (!context.read<DiskusiCubit>().isClosed)
      context.read<DiskusiCubit>().activeUsers(widget.user);
    if (!context.read<MessageBloc>().isClosed)
      context.read<MessageBloc>().add(MessageEvent.onSubscribed(widget.user));

    final chatsCubit = context.read<ChatsCubit>();
    if (!chatsCubit.isClosed) chatsCubit.chats();

    if (!context.read<MessageBloc>().isClosed) {
      print('ardi');
      context.read<MessageBloc>().stream.listen((state) async {
        if (state is MessageReceivedSuccess) {
          if (!chatsCubit.isClosed) {
            await chatsCubit.viewModel.receivedMessage(state.message);
            chatsCubit.chats();
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, List<Chat>>(builder: (_, chats) {
      this.chats = chats;
      if (this.chats.isEmpty) return Container();
      if (!context.read<TypingNotificationBloc>().isClosed) {
        context.read<TypingNotificationBloc>().add(
              TypingNotificationEvent.onSubscribed(
                widget.user,
                usersWithChat: chats.map((e) => e.from!.nik).toList(),
              ),
            );
      }

      return _buildList();
    });
  }

  _buildList() => ListView.separated(
        padding: EdgeInsets.only(top: 30, right: 16),
        itemBuilder: (_, i) => _listItem(chats[i]),
        separatorBuilder: (_, __) => Divider(
          thickness: 1,
          indent: 75,
        ),
        itemCount: chats.length,
      );

  _listItem(Chat chat) => ListTile(
        contentPadding: EdgeInsets.only(left: 16),
        dense: true,
        leading: _profileImage(
          imageUrl: (chat.from != null)
              ? _diskusiBloc.dirImageMember + chat.from!.photoUrl
              : '',
          online: true,
        ),
        title: Text(
          chat.from!.username,
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
        ),
        subtitle: BlocBuilder<TypingNotificationBloc, TypingNotificationState>(
            builder: (_, state) {
          if (state is TypingNotificationReceivedSuccess &&
              state.event.event == Typing.start &&
              state.event.from == chat.from!.nik)
            this.typingEvents.add(state.event.from);

          if (state is TypingNotificationReceivedSuccess &&
              state.event.event == Typing.stop &&
              state.event.from == chat.from!.nik)
            this.typingEvents.remove(state.event.from);

          if (this.typingEvents.contains(chat.from!.nik))
            return Text(
              'Mengetik...',
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(fontStyle: FontStyle.italic),
            );

          return Text(
            chat.mostRecent!.message.contents,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: Theme.of(context).textTheme.overline!.copyWith(
                  color: Colors.black54,
                  fontWeight:
                      chat.unread > 0 ? FontWeight.bold : FontWeight.normal,
                ),
          );
        }),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AFconvert.matDateTime(chat.mostRecent!.message.timestamp),
              style: Theme.of(context).textTheme.overline!.copyWith(
                    color: Colors.black54,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: chat.unread > 0
                    ? Container(
                        height: 15,
                        width: 15,
                        color: Colors.red,
                        alignment: Alignment.center,
                        child: Text(
                          chat.unread.toString(),
                          style: Theme.of(context).textTheme.overline!.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            )
          ],
        ),
        onTap: () async {
          await this.widget.router.onShowMessageThread(
                context,
                chat.from!,
                widget.user,
                chatId: chat.id,
              );
        },
      );

  _profileImage({
    String imageUrl = '',
    bool online = false,
  }) =>
      CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(126),
              child: imageUrl != ''
                  ? AFwidget.cachedNetworkImage(
                      imageUrl,
                      width: 126,
                      height: 126,
                      fit: BoxFit.fill,
                    )
                  : Icon(
                      Icons.person,
                      size: 90,
                    ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: online ? _onlineIndicator() : Container(),
            ),
          ],
        ),
      );

  _onlineIndicator() => Container(
        height: 15,
        width: 15,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 3,
            color: Colors.white,
          ),
        ),
      );
}

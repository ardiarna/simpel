// import 'package:flutter/material.dart';
// import 'package:simpel/blocs/diskusi_bloc.dart';
// import 'package:simpel/chat/blocs/chats_cubit.dart';
// import 'package:simpel/chat/blocs/message/message_bloc.dart';
// import 'package:simpel/chat/blocs/message_group/message_group_bloc.dart';
// import 'package:simpel/chat/blocs/typing/typing_bloc.dart';
// import 'package:simpel/chat/diskusi_route.dart';
// import 'package:simpel/chat/views/message_contact.dart';
// import 'package:simpel/chat/models/chat_model.dart';
// import 'package:simpel/chat/models/typing_event_model.dart';
// import 'package:simpel/chat/models/user_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:simpel/chat/services/user_service.dart';
// import 'package:simpel/chat/viewmodels/chats_view_model.dart';
// import 'package:simpel/chat/views/color_generator.dart';
// import 'package:simpel/chat/views/profil_image.dart';
// import 'package:simpel/models/member_model.dart';
// import 'package:simpel/utils/af_convert.dart';

// class DiskusiPage extends StatefulWidget {
//   final MemberModel member;
//   final User user;
//   final IDiskusiRouter router;
//   final ChatsViewModel viewModel;
//   const DiskusiPage(
//       {required this.member,
//       required this.user,
//       required this.router,
//       required this.viewModel,
//       Key? key})
//       : super(key: key);

//   @override
//   _DiskusiPageState createState() => _DiskusiPageState();
// }

// class _DiskusiPageState extends State<DiskusiPage> {
//   final DiskusiBloc _diskusiBloc = DiskusiBloc();
//   List<Chat> chats = [];
//   // List<User> _activeUsers = [];
//   final typingEvents = [];

//   @override
//   void initState() {
//     super.initState();

//     // if (!context.read<DiskusiCubit>().isClosed)
//     // context.read<DiskusiCubit>().activeUsers(widget.user);
//     // if (!context.read<MessageBloc>().isClosed)
//     context.read<MessageBloc>().add(MessageEvent.onSubscribed(widget.user));
//     context
//         .read<MessageGroupBloc>()
//         .add(MessageGroupEvent.onSubscribed(widget.user));

//     final chatsCubit = context.read<ChatsCubit>();
//     // if (!chatsCubit.isClosed)
//     chatsCubit.chats();

//     // if (!context.read<MessageBloc>().isClosed) {
//     context.read<MessageBloc>().stream.listen((state) async {
//       if (state is MessageReceivedSuccess) {
//         await chatsCubit.viewModel.receivedMessage(state.message);
//         chatsCubit.chats();
//       }
//     });

//     // if (!context.read<MessageGroupBloc>().isClosed)
//     context.read<MessageGroupBloc>().stream.listen((state) async {
//       if (state is MessageGroupReceived) {
//         final group = state.messageGroup;
//         group.members.removeWhere((e) => e == widget.user.nik);
//         final membersId = group.members
//             .map((e) => {e: RandomColorGenerator.getColor().value.toString()})
//             .toList();
//         final chat = Chat(
//           group.id,
//           ChatType.group,
//           name: group.name,
//           membersId: membersId,
//           photoUrl: group.photoUrl,
//         );
//         // if (!chatsCubit.isClosed) {
//         await chatsCubit.viewModel.createNewChat(chat);
//         await chatsCubit.chats();
//         // }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     final UserService userService = UserService();
//     userService.disconnect(widget.user.nik, DateTime.now());
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // titleSpacing: 0,
//         automaticallyImplyLeading: false,
//         title: Row(
//           children: [
//             // IconButton(
//             //   icon: Icon(Icons.arrow_back_ios_rounded),
//             //   onPressed: () {
//             //     Navigator.of(context).pop(true);
//             //   },
//             // ),
//             Expanded(
//               child: Text('Pojok Diskusi'),
//             ),
//             // Expanded(
//             //   child: BlocBuilder<DiskusiCubit, DiskusiState>(
//             //     builder: (_, state) {
//             //       if (state is DiskusiSuccess) {
//             //         _activeUsers = state.onlineUsers;
//             //         return Text('Pojok Diskusi(${state.onlineUsers.length})');
//             //       }
//             //       return Text('Pojok Diskusi');
//             //     },
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//       body: BlocBuilder<ChatsCubit, List<Chat>>(builder: (_, chats) {
//         this.chats = chats;
//         if (this.chats.isEmpty) return Container();
//         List<String> userNiks = [];
//         chats.forEach((chat) {
//           userNiks += chat.members.map((e) => e.nik).toList();
//         });
//         // if (!context.read<TypingNotificationBloc>().isClosed) {
//         context.read<TypingNotificationBloc>().add(
//               TypingNotificationEvent.onSubscribed(
//                 widget.user,
//                 usersWithChat: userNiks.toSet().toList(),
//               ),
//             );
//         // }
//         return _buildList();
//       }),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.insert_comment),
//         onPressed: () async {
//           var a = await Navigator.of(context).push<List<User>>(
//             MaterialPageRoute(
//               builder: (context) => MessageContact(member: widget.member),
//             ),
//           );
//           if (a != null) {
//             await this.widget.router.onShowMessageThread(
//                   context: context,
//                   receivers: a,
//                   me: widget.user,
//                   chat: Chat('', ChatType.individual),
//                 );
//             context.read<ChatsCubit>().chats();
//           }
//         },
//       ),
//       //     FloatingActionButton(
//       //   child: Icon(
//       //     Icons.group_add_rounded,
//       //   ),
//       //   onPressed: () async {
//       //     await widget.router.onShowCreateGroup(
//       //       context,
//       //       _activeUsers,
//       //       widget.user,
//       //     );
//       //   },
//       // ),
//     );
//   }

//   _buildList() => ListView.separated(
//         padding: EdgeInsets.only(top: 30, right: 16),
//         itemBuilder: (_, i) => _listItem(chats[i]),
//         separatorBuilder: (_, __) => Divider(
//           thickness: 1,
//           indent: 75,
//         ),
//         itemCount: chats.length,
//       );

//   _listItem(Chat chat) => ListTile(
//         contentPadding: EdgeInsets.only(left: 16),
//         dense: true,
//         leading: ProfilImage(
//           imageUrl: (chat.type == ChatType.individual)
//               ? chat.members.first.photoUrl != ''
//                   ? '${_diskusiBloc.dirImage}${chat.members.first.kategori}/${chat.members.first.photoUrl}'
//                   : ''
//               : chat.photoUrl != ''
//                   ? _diskusiBloc.dirImageGiat + chat.photoUrl
//                   : '',
//           online: chat.type == ChatType.individual
//               ? chat.members.first.active
//               : false,
//         ),
//         title: Text(
//           chat.type == ChatType.individual
//               ? chat.members.first.username
//               : chat.name,
//           style: Theme.of(context).textTheme.subtitle2!.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//         ),
//         subtitle: BlocBuilder<TypingNotificationBloc, TypingNotificationState>(
//             builder: (_, state) {
//           if (state is TypingNotificationReceivedSuccess &&
//               state.event.event == Typing.start &&
//               state.event.chatId == chat.id)
//             this.typingEvents.add(state.event.chatId);

//           if (state is TypingNotificationReceivedSuccess &&
//               state.event.event == Typing.stop &&
//               state.event.chatId == chat.id)
//             this.typingEvents.remove(state.event.chatId);

//           if (this.typingEvents.contains(chat.id)) {
//             switch (chat.type) {
//               case ChatType.group:
//                 final st = state as TypingNotificationReceivedSuccess;
//                 final username = chat.members
//                     .firstWhere((e) => e.nik == st.event.from)
//                     .username;
//                 return Text(
//                   '$username sedang mengetik...',
//                   style: Theme.of(context)
//                       .textTheme
//                       .caption!
//                       .copyWith(fontStyle: FontStyle.italic),
//                 );

//               default:
//                 return Text(
//                   'Mengetik...',
//                   style: Theme.of(context)
//                       .textTheme
//                       .caption!
//                       .copyWith(fontStyle: FontStyle.italic),
//                 );
//             }
//           }
//           return Text(
//             chat.mostRecent != null
//                 ? chat.type == ChatType.individual
//                     ? chat.mostRecent!.message.contents
//                     : (chat.members
//                             .firstWhere(
//                                 (e) => e.nik == chat.mostRecent!.message.from,
//                                 orElse: () => User(username: 'Anda'))
//                             .username) +
//                         ': ' +
//                         chat.mostRecent!.message.contents
//                 : 'Diskusi Grup Dibuat',
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             softWrap: true,
//             style: Theme.of(context).textTheme.overline!.copyWith(
//                   color: Colors.black54,
//                   fontWeight:
//                       chat.unread > 0 ? FontWeight.bold : FontWeight.normal,
//                 ),
//           );
//         }),
//         trailing: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             if (chat.mostRecent != null)
//               Text(
//                 AFconvert.matDateTime(chat.mostRecent!.message.timestamp),
//                 style: Theme.of(context).textTheme.overline!.copyWith(
//                       color: Colors.black54,
//                     ),
//               ),
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(50),
//                 child: chat.unread > 0
//                     ? Container(
//                         height: 15,
//                         width: 15,
//                         color: Colors.red,
//                         alignment: Alignment.center,
//                         child: Text(
//                           chat.unread.toString(),
//                           style: Theme.of(context).textTheme.overline!.copyWith(
//                                 color: Colors.white,
//                               ),
//                         ),
//                       )
//                     : SizedBox.shrink(),
//               ),
//             )
//           ],
//         ),
//         onTap: () async {
//           await this.widget.router.onShowMessageThread(
//                 context: context,
//                 receivers: chat.members,
//                 me: widget.user,
//                 chat: chat,
//               );
//           context.read<ChatsCubit>().chats();
//         },
//       );
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpel/blocs/diskusi_bloc.dart';
import 'package:simpel/chat/blocs/chats_cubit.dart';
import 'package:simpel/chat/blocs/group_cubit.dart';
import 'package:simpel/chat/blocs/message_group/message_group_bloc.dart';
import 'package:simpel/chat/diskusi_route.dart';
import 'package:simpel/chat/models/chat_model.dart';
import 'package:simpel/chat/models/message_group_model.dart';
import 'package:simpel/chat/models/user_model.dart';
import 'package:simpel/chat/views/color_generator.dart';
import 'package:simpel/chat/views/profil_image.dart';
import 'package:simpel/utils/af_widget.dart';

class CreateGroup extends StatefulWidget {
  final List<User> _activeUser;
  final User _me;
  final ChatsCubit _chatsCubit;
  final IDiskusiRouter _router;
  const CreateGroup(
    this._activeUser,
    this._me,
    this._chatsCubit,
    this._router,
  );

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final DiskusiBloc _diskusiBloc = DiskusiBloc();
  List<User> selectedUsers = [];
  late GroupCubit _groupCubit;
  late ChatsCubit _chatsCubit;
  late MessageGroupBloc _messageGroupBloc;
  String _groupNama = '';

  @override
  void initState() {
    super.initState();
    _groupCubit = context.read<GroupCubit>();
    _chatsCubit = widget._chatsCubit;
    _messageGroupBloc = context.read<MessageGroupBloc>();

    _messageGroupBloc.stream.listen((state) async {
      if (state is MessageGroupCreatedSuccess) {
        state.messageGroup.members.removeWhere((e) => e == widget._me.nik);
        final membersId = state.messageGroup.members
            .map((e) => {e: RandomColorGenerator.getColor().value.toString()})
            .toList();
        final chat = Chat(
          state.messageGroup.id,
          ChatType.group,
          membersId: membersId,
          name: _groupNama,
        );
        await _chatsCubit.viewModel.createNewChat(chat);
        final chats = await _chatsCubit.viewModel.getChats();
        final receivers = chats
            .firstWhere((chat) => chat.id == state.messageGroup.id)
            .members;
        await _chatsCubit.chats();
        Navigator.of(context).pop();
        widget._router.onShowMessageThread(
          context: context,
          receivers: receivers,
          me: widget._me,
          chat: chat,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GroupCubit, List<User>>(
        bloc: _groupCubit,
        builder: (_, state) {
          selectedUsers = state;
          return SizedBox.expand(
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(selectedUsers.length > 1),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: AFwidget.textField(
                      context: context,
                      label: 'Nama Grup',
                      textInputAction: TextInputAction.done,
                      onchanged: (val) {
                        _groupNama = val;
                      }),
                ),
                state.isEmpty
                    ? SizedBox.shrink()
                    : Container(
                        height: 65,
                        child: ListView.builder(
                          itemBuilder: (_, i) =>
                              _selectedUserListItem(selectedUsers[i]),
                          itemCount: selectedUsers.length,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                Expanded(
                  child: _buildList(widget._activeUser),
                ),
              ],
            )),
          );
        },
      ),
    );
  }

  _header(bool enableButton) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: 40,
          child: Row(
            children: [
              TextButton(
                style: ButtonStyle(
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        Theme.of(context).textTheme.caption!)),
                child: Text('Batal'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Center(
                child: Text(
                  'Group Baru',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              TextButton(
                style: ButtonStyle(
                    textStyle: MaterialStateProperty.all<TextStyle>(
                        Theme.of(context).textTheme.caption!)),
                child: Text('Buat Grup'),
                onPressed: enableButton
                    ? () {
                        if (_groupNama.isEmpty) {
                          AFwidget.snack(context, 'Isi nama grup');
                          return;
                        }
                        _createGrup();
                      }
                    : null,
              ),
            ],
          ),
        ),
      );

  _buildList(List<User> users) => ListView.separated(
        padding: EdgeInsets.only(top: 20, right: 2),
        itemBuilder: (context, i) => GestureDetector(
          child: _listItem(users[i]),
          onTap: () {
            if (selectedUsers.any((element) => element.nik == users[i].nik)) {
              _groupCubit.remove(users[i]);
              return;
            }
            _groupCubit.add(users[i]);
          },
        ),
        separatorBuilder: (_, __) => Divider(
          endIndent: 16,
        ),
        itemCount: users.length,
      );

  _listItem(User user) => ListTile(
        leading: ProfilImage(
          imageUrl: user.photoUrl != ''
              ? _diskusiBloc.dirImage + user.kategori + '/' + user.photoUrl
              : '',
          online: true,
        ),
        title: Text(
          user.username,
          style: Theme.of(context).textTheme.caption!.copyWith(
                fontSize: 12,
              ),
        ),
        trailing: _checkBox(
          size: 20,
          isChecked: selectedUsers.any((element) => element.nik == user.nik),
        ),
      );

  _checkBox({required double size, required bool isChecked}) => ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: isChecked ? Colors.green : Colors.transparent,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(size / 2),
          ),
        ),
      );

  _createGrup() {
    MessageGroup messageGroup = MessageGroup(
        createdBy: widget._me.nik,
        name: _groupNama,
        members: selectedUsers.map<String>((e) => e.nik).toList() +
            [widget._me.nik]);
    final event = MessageGroupEvent.onGroupCreated(messageGroup);
    _messageGroupBloc.add(event);
  }

  _selectedUserListItem(User user) => Padding(
        padding: EdgeInsets.only(right: 8),
        child: GestureDetector(
          onTap: () => _groupCubit.remove(user),
          child: Container(
            width: 40,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 30,
                    child: user.photoUrl != ''
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: AFwidget.cachedNetworkImage(
                              _diskusiBloc.dirImage +
                                  user.kategori +
                                  '/' +
                                  user.photoUrl,
                              fit: BoxFit.fill,
                              width: 40,
                              height: 40,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 25,
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    user.username.split(' ').first,
                    softWrap: false,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:simpel/chat/models/chat_model.dart';
import 'package:simpel/chat/models/local_message_model.dart';
import 'package:simpel/chat/models/user_model.dart';
import 'package:simpel/chat/views/profil_image.dart';
import 'package:simpel/utils/af_convert.dart';
import 'package:simpel/utils/db_helper.dart';

class ReceiverMessage extends StatelessWidget {
  final User _user;
  final LocalMessage _message;
  final ChatType type;
  final Color? color;

  ReceiverMessage(
    this._message,
    this._user,
    this.type, {
    Color? color,
  }) : this.color = color;

  final String _dirImageMember = DBHelper.dirImage + 'member/';

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.topLeft,
      widthFactor: 0.75,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: type == ChatType.group ? 20 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (type == ChatType.group)
                  Padding(
                    padding: EdgeInsets.only(left: 22, bottom: 2),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        _user.username,
                        softWrap: true,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ),
                    ),
                  ),
                DecoratedBox(
                  decoration: type == ChatType.group
                      ? BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        )
                      : BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(35),
                            bottomRight: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                  position: DecorationPosition.background,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    child: Text(
                      _message.message.contents.trim(),
                      softWrap: true,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(height: 1.2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 12),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      AFconvert.matDateTime(_message.message.timestamp),
                      style: Theme.of(context)
                          .textTheme
                          .overline!
                          .copyWith(color: Colors.black54),
                    ),
                  ),
                )
              ],
            ),
          ),
          type == ChatType.group
              ? Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 5),
                  child: ProfilImage(
                    imageUrl: _user.photoUrl != ''
                        ? _dirImageMember + _user.photoUrl
                        : '',
                    online: _user.active,
                    size: 30,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                    ),
                    child: Container(
                      color: Colors.grey.shade200,
                      height: 40,
                      width: 15,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

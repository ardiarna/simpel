import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simpel/utils/af_widget.dart';

class HeaderStatus extends StatelessWidget {
  final String username;
  final String imageUrl;
  final bool online;
  final DateTime? lastSeen;
  final bool typing;
  const HeaderStatus(this.username, this.imageUrl, this.online,
      {this.lastSeen, this.typing = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Row(
        children: [
          _profileImage(
            imageUrl: imageUrl,
            online: online,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  username.trim(),
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: !typing
                    ? Text(
                        online
                            ? 'online'
                            : 'terakhir terlihat ${DateFormat.yMd().add_jm().format}',
                        style: Theme.of(context).textTheme.caption,
                      )
                    : Text(
                        'mengetik...',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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

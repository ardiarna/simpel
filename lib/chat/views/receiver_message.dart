import 'package:flutter/material.dart';
import 'package:simpel/chat/models/local_message_model.dart';
import 'package:simpel/utils/af_convert.dart';
import 'package:simpel/utils/af_widget.dart';

class ReceiverMessage extends StatelessWidget {
  final String _url;
  final LocalMessage _message;

  const ReceiverMessage(this._message, this._url);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.topLeft,
      widthFactor: 0.75,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
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
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 18,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _url != ''
                  ? AFwidget.cachedNetworkImage(
                      _url,
                      height: 30,
                      width: 30,
                      fit: BoxFit.fill,
                    )
                  : Icon(
                      Icons.person,
                      size: 25,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

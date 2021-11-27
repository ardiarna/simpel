import 'package:flutter/material.dart';
import 'package:simpel/chat/views/profil_image.dart';

class HeaderStatus extends StatelessWidget {
  final String username;
  final String imageUrl;
  final bool online;
  final String description;
  final String typing;
  const HeaderStatus(
    this.username,
    this.imageUrl,
    this.online, {
    this.description = '',
    this.typing = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Row(
        children: [
          ProfilImage(
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
                        color: Colors.white,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: typing == ''
                    ? Text(
                        online ? 'online' : description,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              color: Colors.white,
                            ),
                      )
                    : Text(
                        typing,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                            ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

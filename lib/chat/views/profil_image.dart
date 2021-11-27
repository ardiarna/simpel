import 'package:flutter/material.dart';
import 'package:simpel/utils/af_widget.dart';

class ProfilImage extends StatelessWidget {
  final String imageUrl;
  final bool online;
  final double size;

  ProfilImage({
    required this.imageUrl,
    required this.online,
    this.size = 126,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(126),
            child: imageUrl != ''
                ? AFwidget.cachedNetworkImage(
                    imageUrl,
                    width: size,
                    height: size,
                    fit: BoxFit.fill,
                  )
                : Icon(
                    Icons.person,
                    size: 25,
                  ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: online ? _onlineIndicator() : Container(),
          ),
        ],
      ),
    );
  }

  _onlineIndicator() => Container(
        height: size / 8,
        width: size / 8,
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

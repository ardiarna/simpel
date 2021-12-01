import 'package:flutter/material.dart';
import 'package:simpel/utils/af_widget.dart';

class ProfilImage extends StatelessWidget {
  final String imageUrl;
  final bool online;
  final double size;
  final bool isUseImage;

  ProfilImage({
    required this.imageUrl,
    required this.online,
    this.size = 40,
    this.isUseImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(size),
      ),
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          !isUseImage || imageUrl == ''
              ? Icon(
                  Icons.person,
                  size: size / 1.6,
                  color: Colors.white,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(size),
                  child: AFwidget.cachedNetworkImage(
                    imageUrl,
                    width: size,
                    height: size,
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
        height: size / 3.5,
        width: size / 3.5,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(size / 3.5),
          border: Border.all(
            width: 1.5,
            color: Colors.white,
          ),
        ),
      );
}

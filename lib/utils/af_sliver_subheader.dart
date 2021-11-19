import 'dart:math';

import 'package:flutter/material.dart';

class AFsliverSubHeader extends StatelessWidget {
  final Widget child;
  final double minHeight;
  final double maxHeight;
  final Color color;

  const AFsliverSubHeader({
    Key? key,
    required this.child,
    this.minHeight = 50,
    this.maxHeight = 100,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _AFsliverPersistentHeaderDelegate(
        minHeight: minHeight,
        maxHeight: maxHeight,
        child: Container(
          child: child,
          color: color,
        ),
      ),
    );
  }
}

class _AFsliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _AFsliverPersistentHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_AFsliverPersistentHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

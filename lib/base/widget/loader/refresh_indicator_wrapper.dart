import 'package:flutter/material.dart';
import 'package:galerio/base/widget/list/list.dart';
import 'package:galerio/constants.dart';

class RefreshIndicatorNonScrollableWrapper extends StatelessWidget {
  final Widget child;
  final RefreshCallback onRefresh;

  const RefreshIndicatorNonScrollableWrapper({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      color: colorPrimary,
      backgroundColor: Colors.white,
      onRefresh: onRefresh,
      child: Stack(
        children: [
          const BlankViewportListView(),
          child,
        ],
      ),
    );
  }
}

class RefreshIndicatorScrollableWrapper extends StatelessWidget {
  final Widget child;
  final RefreshCallback onRefresh;

  const RefreshIndicatorScrollableWrapper({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      color: colorPrimary,
      backgroundColor: Colors.white,
      onRefresh: onRefresh,
      child: child,
    );
  }
}

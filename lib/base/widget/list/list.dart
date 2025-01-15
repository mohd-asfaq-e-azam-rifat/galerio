import 'package:flutter/material.dart';

class BlankViewportListView extends StatelessWidget {
  const BlankViewportListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
        ),
      ],
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:galerio/constants.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Albums"),
        titleTextStyle: textStyleAppBarTitle1,
      ),
      body: GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 items per row
          crossAxisSpacing: 4.0, // space between items horizontally
          mainAxisSpacing: 6.0, // space between items vertically
          childAspectRatio: 1, // width and height are the same
        ),
        itemCount: 30,
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  "https://placebear.com/${600 + index}/${600 + index}",
                ),
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.5),
                  BlendMode.darken,
                ),
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 14.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.0,
              children: [
                Text(
                  "All",
                  style: textStyleAlbumTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${Random().nextInt(999)} Photos",
                  style: textStyleAlbumSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

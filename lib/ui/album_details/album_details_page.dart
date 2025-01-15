import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galerio/base/navigation/navigation.dart';
import 'package:galerio/constants.dart';
import 'package:galerio/routes/routes.dart';

class AlbumDetailsPage extends StatelessWidget {
  const AlbumDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    final appBarTheme = Theme.of(context).appBarTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20.0,
            color: colorText1,
          ),
          onPressed: () {
            context.back();
          },
        ),
        title: Text("Recent"),
        titleTextStyle: textStyleAppBarTitle2,
        systemOverlayStyle: appBarTheme.systemOverlayStyle?.copyWith(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarContrastEnforced: false,
        ),
      ),
      body: GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 4 items per row
          crossAxisSpacing: 4.0, // space between items horizontally
          mainAxisSpacing: 4.0, // space between items vertically
          childAspectRatio: 1, // width and height are the same
        ),
        itemCount: 60,
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.to(Routes.photoPreviewer);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.8),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    "https://placebear.com/${600 + index}/${600 + index}",
                  ),
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          );
        },
      ),
    );
  }
}

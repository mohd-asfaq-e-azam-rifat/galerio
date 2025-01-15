import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galerio/base/navigation/navigation.dart';
import 'package:galerio/constants.dart';

class PhotoPreviewerPage extends StatelessWidget {
  const PhotoPreviewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    final appBarTheme = Theme.of(context).appBarTheme;

    return Scaffold(
      backgroundColor: colorPrimary,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20.0,
            color: Colors.white,
          ),
          onPressed: () {
            context.back();
          },
        ),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: appBarTheme.systemOverlayStyle?.copyWith(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarContrastEnforced: false,
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: InteractiveViewer(
        panEnabled: true,
        maxScale: 4.0,
        child: Center(
          child: Image.network(
            "https://placebear.com/720/1280",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galerio/base/app_config/app_config_bloc.dart';
import 'package:galerio/base/app_config/app_config_state.dart';
import 'package:galerio/base/di/app_module.dart';
import 'package:galerio/base/navigation/navigation.dart';
import 'package:galerio/base/state/basic/basic_state.dart';
import 'package:galerio/base/theme/light_theme.dart';
import 'package:galerio/injection.dart';
import 'package:galerio/routes/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configurePreDependencies();

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ).then(
    (_) {
      runApp(const MyApp());
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the following flag to handle debugging layout size visibility
    debugPaintSizeEnabled = false;

    return MultiBlocProvider(
      providers: [
        BlocProvider<AppConfigBloc>(
          create: (_) => getIt<AppConfigBloc>(),
        ),
      ],
      child: BlocConsumer<AppConfigBloc, AppConfigState>(
        listener: (context, state) {
          if (state.authState.isAuthorized == true) {
            appContext?.to(Routes.album, clearBackstack: true);
          } else {
            appContext?.to(Routes.requestPermission, clearBackstack: true);
          }
        },
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: AppConfigState.appKey,
            initialRoute: Routes.initialRoute,
            onGenerateRoute: onGenerateRoute,
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            builder: (context, child) {
              // Restrict device font size to override our app fonts
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.noScaling,
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}

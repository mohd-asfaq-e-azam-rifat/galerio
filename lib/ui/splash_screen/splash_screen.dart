import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galerio/base/app_config/app_config_bloc.dart';
import 'package:galerio/base/app_config/app_config_event.dart';
import 'package:galerio/base/widget/loader/base_data_loader.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  AppConfigBloc _getBloc(BuildContext context) {
    final bloc = context.read<AppConfigBloc>();
    bloc.add(AppInitialDataRequested());

    return bloc;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _getBloc(context),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BaseDataLoader(),
            ],
          ),
        ),
      ),
    );
  }
}

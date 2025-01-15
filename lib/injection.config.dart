// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:galerio/base/app_config/app_config_bloc.dart' as _i762;
import 'package:galerio/base/di/app_module.dart' as _i608;
import 'package:galerio/base/helper/debounce.dart' as _i21;
import 'package:galerio/data/helper/date_time/date.dart' as _i861;
import 'package:galerio/data/helper/encryption/encryption_helper.dart' as _i159;
import 'package:galerio/data/helper/network/interceptors.dart' as _i772;
import 'package:galerio/data/model/local/app_info/app_info.dart' as _i32;
import 'package:galerio/data/repository/auth_repository.dart' as _i857;
import 'package:galerio/data/repository/common_repository.dart' as _i1021;
import 'package:galerio/data/service/local/auth_local_service.dart' as _i57;
import 'package:galerio/data/service/local/common_local_service.dart' as _i844;
import 'package:galerio/data/service/remote/auth_remote_service.dart' as _i599;
import 'package:galerio/data/service/remote/common_remote_service.dart'
    as _i881;
import 'package:get_it/get_it.dart' as _i174;
import 'package:get_storage/get_storage.dart' as _i792;
import 'package:injectable/injectable.dart' as _i526;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final appModule = _$AppModule();
  gh.factory<_i159.EncryptionHelper>(() => _i159.EncryptionHelper());
  gh.factory<_i772.BaseInterceptor>(() => _i772.BaseInterceptor());
  gh.factory<_i861.DateTimeHelper>(() => _i861.DateTimeHelper());
  await gh.factoryAsync<_i792.GetStorage>(
    () => appModule.getStorage,
    preResolve: true,
  );
  await gh.factoryAsync<_i32.AppInfo>(
    () => appModule.appInfo,
    preResolve: true,
  );
  gh.factory<_i361.Dio>(() => appModule.dioClient);
  gh.factory<_i21.DebounceHelper>(() => _i21.DebounceHelper());
  gh.factory<_i844.CommonLocalService>(
      () => _i844.CommonLocalService(gh<_i792.GetStorage>()));
  gh.factory<_i57.AuthLocalService>(
      () => _i57.AuthLocalService(gh<_i792.GetStorage>()));
  gh.factory<_i599.AuthRemoteService>(
      () => _i599.AuthRemoteService(gh<_i361.Dio>()));
  gh.factory<_i881.CommonRemoteService>(
      () => _i881.CommonRemoteService(gh<_i361.Dio>()));
  gh.factory<_i1021.CommonRepository>(() => _i1021.CommonRepository(
        gh<_i844.CommonLocalService>(),
        gh<_i881.CommonRemoteService>(),
      ));
  gh.factory<_i857.AuthRepository>(() => _i857.AuthRepository(
        gh<_i57.AuthLocalService>(),
        gh<_i599.AuthRemoteService>(),
      ));
  gh.factory<_i762.AppConfigBloc>(() => _i762.AppConfigBloc(
        gh<_i1021.CommonRepository>(),
        gh<_i857.AuthRepository>(),
      ));
  return getIt;
}

class _$AppModule extends _i608.AppModule {}

import 'package:galerio/base/di/app_module.dart';
import 'package:galerio/base/env/env_dev.dart';
import 'package:galerio/base/env/env_prod.dart';

abstract class Env {
  static final String apiKey =
      isDevFlavor == true ? EnvDev.apiKey : EnvProd.apiKey;

  static final String baseUrl =
      isDevFlavor == true ? EnvDev.baseUrl : EnvProd.baseUrl;

  static final String encryptionKey =
      isDevFlavor == true ? EnvDev.encryptionKey : EnvProd.encryptionKey;

  static final String ivKey =
      isDevFlavor == true ? EnvDev.ivKey : EnvProd.ivKey;
}

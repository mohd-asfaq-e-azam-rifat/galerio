import 'package:envied/envied.dart';

part 'env_dev.g.dart';

@Envied(
  name: 'EnvDev',
  path: 'env/.env.dev',
  obfuscate: false,
)
abstract class EnvDev {
  @EnviedField(varName: 'api_key', defaultValue: "")
  static const String apiKey = _EnvDev.apiKey;

  @EnviedField(varName: 'base_url', defaultValue: "")
  static const String baseUrl = _EnvDev.baseUrl;

  @EnviedField(varName: 'encryption_key', defaultValue: "")
  static const String encryptionKey = _EnvDev.encryptionKey;

  @EnviedField(varName: 'iv_key', defaultValue: "")
  static const String ivKey = _EnvDev.ivKey;
}

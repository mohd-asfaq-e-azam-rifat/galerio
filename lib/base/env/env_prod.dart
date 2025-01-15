import 'package:envied/envied.dart';

part 'env_prod.g.dart';

@Envied(
  name: 'EnvProd',
  path: 'env/.env.prod',
  obfuscate: false,
)
abstract class EnvProd {
  @EnviedField(varName: 'api_key', defaultValue: "")
  static const String apiKey = _EnvProd.apiKey;

  @EnviedField(varName: 'base_url', defaultValue: "")
  static const String baseUrl = _EnvProd.baseUrl;

  @EnviedField(varName: 'encryption_key', defaultValue: "")
  static const String encryptionKey = _EnvProd.encryptionKey;

  @EnviedField(varName: 'iv_key', defaultValue: "")
  static const String ivKey = _EnvProd.ivKey;
}

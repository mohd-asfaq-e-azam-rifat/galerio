import 'package:encrypt/encrypt.dart';
import 'package:galerio/base/env/env.dart';
import 'package:injectable/injectable.dart';

@injectable
@lazySingleton
class EncryptionHelper {
  Encrypter? _client;
  IV? _iv;

  EncryptionHelper() {
    final key = Key.fromBase64(Env.encryptionKey);
    _iv = IV.fromBase64(Env.ivKey);
    _client = Encrypter(AES(key));
  }

  String? encrypt(String data) {
    return _client?.encrypt(data, iv: _iv).base64;
  }

  String? decrypt(String data) {
    return _client?.decrypt64(data, iv: _iv);
  }
}

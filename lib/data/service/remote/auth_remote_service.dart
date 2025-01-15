import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
@lazySingleton
class AuthRemoteService {
  final Dio _client;

  AuthRemoteService(this._client);
}

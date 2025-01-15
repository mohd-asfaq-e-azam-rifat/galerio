import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
@singleton
class CommonRemoteService {
  final Dio _client;

  CommonRemoteService(this._client);
}

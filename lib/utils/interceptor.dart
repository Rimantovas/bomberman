import 'package:dio/dio.dart';

class PlayerIdHeaderIntercepter extends Interceptor {
  final String playerId;

  PlayerIdHeaderIntercepter(this.playerId);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['player-id'] = playerId;
    super.onRequest(options, handler);
  }
}

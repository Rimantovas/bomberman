import 'package:bomberman/utils/http/http_client.dart';

class PlayerIdHeaderIntercepter extends HttpInterceptor {
  final String playerId;

  PlayerIdHeaderIntercepter(this.playerId);

  @override
  void onRequest(HttpRequest request) {
    request.headers['player-id'] = playerId;
  }

  @override
  void onError(APIResponse<dynamic> error) {
    // TODO: implement onError
  }

  @override
  void onResponse(APIResponse<dynamic> response) {
    // TODO: implement onResponse
  }
}

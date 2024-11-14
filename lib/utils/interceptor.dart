import 'package:bomberman/utils/http/http_client.dart';

class PlayerIdHeaderIntercepter extends HttpInterceptor {
  final String playerId;

  PlayerIdHeaderIntercepter(this.playerId);

  @override
  HttpRequest onRequest(HttpRequest request) {
    final newRequest = HttpRequest(
        path: request.path,
        queryParameters: request.queryParameters,
        data: request.data,
        headers: {
          ...request.headers,
          'player-id': playerId,
        });
    return newRequest;
  }

  @override
  APIResponse onError(APIResponse<dynamic> error) {
    // TODO: implement onError
    return error;
  }

  @override
  APIResponse onResponse(APIResponse<dynamic> response) {
    // TODO: implement onResponse
    return response;
  }
}

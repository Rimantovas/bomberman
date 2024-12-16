import 'package:bomberman/utils/http/http_client.dart';
import 'package:bomberman/utils/iterable_map.dart';

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

//* [PATTERN] Implements Iterator Pattern
class SnakeCaseInterceptor extends HttpInterceptor {
  @override
  HttpRequest onRequest(HttpRequest request) {
    final newRequest = HttpRequest(
        path: request.path,
        queryParameters: request.queryParameters,
        data: MapIterator(_convertToSnakeCase(request.data)),
        headers: request.headers);
    return newRequest;
  }

  dynamic _convertToSnakeCase(MapIterator? data) {
    if (data == null) return null;
    final Map<String, dynamic> snakeCaseData = {};
    while (data.moveNext()) {
      final key = data.current.key;
      final value = data.current.value;
      final snakeCaseKey = _toSnakeCase(key);
      snakeCaseData[snakeCaseKey] = value;
    }
    return snakeCaseData;
  }

  String _toSnakeCase(String input) {
    return input.replaceAllMapped(RegExp(r'[A-Z]'), (match) {
      return '_${match.group(0)!.toLowerCase()}';
    });
  }

  @override
  APIResponse onError(APIResponse<dynamic> error) {
    return error;
  }

  @override
  APIResponse onResponse(APIResponse<dynamic> response) {
    return response;
  }
}

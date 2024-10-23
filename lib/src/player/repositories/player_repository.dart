import 'package:bomberman/main.dart';
import 'package:bomberman/src/player/models/player_move_request.dart';

class PlayerRepository {
  static const String kPlayersPath = '/players';
  static const String kMovePath = '/move';

  static const String kPlayersCollection = 'session_players';

  Future<void> move(PlayerMoveRequest request) async {
    final response =
        await dio.patch('$kPlayersPath$kMovePath', data: request.toMap());

    if (response.statusCode! > 300) {
      throw Exception(response.statusMessage);
    }
  }
}

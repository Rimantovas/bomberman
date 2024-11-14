import 'package:bomberman/main.dart';
import 'package:bomberman/src/player/models/player_move_request.dart';

class PlayerRepository {
  static const String kPlayersPath = '/players';
  static const String kMovePath = '/move';
  static const String kPlayersCollection = 'session_players';

  PlayerRepository();

  Future<void> move(PlayerMoveRequest request) async {
    final data = request.toMap();
    final response = await httpClient.patch(
      '$kPlayersPath$kMovePath',
      data: data,
    );

    print(response.statusCode);

    if (response.statusCode! > 300) {
      throw Exception(response.errorMessage);
    }
  }
}

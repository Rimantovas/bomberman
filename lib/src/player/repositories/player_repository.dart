import 'package:bomberman/main.dart';
import 'package:bomberman/src/player/models/player.dart';
import 'package:bomberman/src/player/models/player_move_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerRepository {
  static const String kPlayersPath = '/players';
  static const String kMovePath = '/move';

  static const String kPlayersCollection = 'session_players';

  final _firestore = FirebaseFirestore.instance;

  Future<void> move(PlayerMoveRequest request) async {
    final response =
        await dio.post('$kPlayersPath$kMovePath', data: request.toJson());

    if (response.statusCode! > 300) {
      throw Exception(response.statusMessage);
    }
  }

  Stream<List<PlayerModel>> getPlayersStream(String sessionId) {
    return _firestore
        .collection(kPlayersPath)
        .where('session_id', isEqualTo: sessionId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PlayerModelMapper.fromMap(doc.data()))
              .toList(),
        );
  }
}

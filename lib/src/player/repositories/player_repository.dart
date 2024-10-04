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
        await dio.patch('$kPlayersPath$kMovePath', data: request.toMap());

    if (response.statusCode! > 300) {
      throw Exception(response.statusMessage);
    }
  }

  Stream<List<PlayerModel>> getPlayersStream(String sessionId) {
    print('GET PLAYERS STREAM $sessionId');
    try {
      return _firestore
          .collection(kPlayersCollection)
          .where('session_id', isEqualTo: sessionId)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => PlayerModelMapper.fromMap({
                      ...doc.data(),
                      'id': doc.id,
                    }))
                .toList(),
          );
    } catch (e) {
      print('ERROR GETTING PLAYERS STREAM $e');
      return Stream.value([]);
    }
  }
}

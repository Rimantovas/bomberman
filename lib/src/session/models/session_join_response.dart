// This file is "model.dart"
import 'package:bomberman/src/player/models/player.dart';
import 'package:dart_mappable/dart_mappable.dart';

// Will be generated by dart_mappable
part 'session_join_response.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
)
class SessionJoinResponse with SessionJoinResponseMappable {
  final String sessionId;
  final String playerId;
  final List<PlayerModel> players;
  SessionJoinResponse(this.sessionId, this.playerId, this.players);
}

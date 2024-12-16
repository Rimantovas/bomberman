// This file is "model.dart"
import 'package:dart_mappable/dart_mappable.dart';

// Will be generated by dart_mappable
part 'player.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
)
class PlayerModel with PlayerModelMappable {
  final String id;
  final String sessionId;
  final int positionX;
  final int positionY;
  final int health;
  PlayerModel(this.id, this.sessionId, this.positionX, this.positionY,
      {this.health = 100});
}

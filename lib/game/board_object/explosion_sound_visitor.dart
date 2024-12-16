import 'package:bomberman/audio/audio_manager.dart';
import 'package:bomberman/game.dart';
import 'package:bomberman/game/board_object/bedrock.dart';
import 'package:bomberman/game/board_object/board_object.dart';
import 'package:bomberman/game/board_object/board_object_visitor.dart';
import 'package:bomberman/game/board_object/destroyable.dart';
import 'package:bomberman/game/board_object/ground.dart';

//* [Pattern] Visitor Pattern
class ExplosionSoundVisitor implements BoardObjectVisitor {
  @override
  void visit(BoardObject object, BombermanGame gameRef, int gridY, int gridX) {
    var assetPath = '';
    if (object is Destroyable) {
      assetPath = 'assets/audio/destroyable_destroy.mp3';
    } else if (object is Bedrock) {
      assetPath = 'assets/audio/bedrock_sound.mp3';
    } else if (object is Ground) {
      assetPath = 'assets/audio/ground_sound.mp3';
    }

    AudioManager().playEffect(assetPath);
  }
}

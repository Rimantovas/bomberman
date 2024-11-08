import 'package:bomberman/enums/game_theme.dart';
import 'package:bomberman/game/map/game_map.dart';
import 'package:bomberman/game/movement/keyboard_handler.dart';
import 'package:bomberman/game/player/player.dart';
import 'package:bomberman/game/player/player_manager.dart';
import 'package:bomberman/game/rendering/color_scheme.dart';
import 'package:bomberman/src/player/models/player.dart';
import 'package:flame/components.dart';

class GameFacade {
  late final PlayerManager playerManager;
  late final GameMap gameMap;
  late final AppKeyboardHandler keyboardHandler;

  Future<void> initializeGame({
    required List<String> asciiMap,
    required String playerId,
    required GameTheme theme,
  }) async {
    await _initializeMap(asciiMap, theme);
    await _initializePlayers(playerId);
    _initializeControls(playerId);
  }

  Future<void> _initializeMap(List<String> asciiMap, GameTheme theme) async {
    gameMap = GameMap(asciiMap: asciiMap, theme: theme);
    gameMap.initStart();
  }

  Future<void> _initializePlayers(String playerId) async {
    playerManager = PlayerManager();
    final myPlayer = Player(
      id: playerId,
      position: Vector2(32, 32),
      colorImplementor: BlueColorImplementor(),
    );
    await playerManager.setMyPlayer(myPlayer);
  }

  void _initializeControls(String playerId) {
    keyboardHandler = AppKeyboardHandler(playerManager.myPlayer);
  }

  void updatePlayers(List<PlayerModel> otherPlayers) {
    for (final player in otherPlayers) {
      if (playerManager.getPlayer(player.id) == null) {
        _addPlayer(player);
      } else {
        _updatePlayerPosition(player);
      }
    }
    playerManager.removePlayersNotIn(otherPlayers.map((p) => p.id).toList());
  }

  void _addPlayer(PlayerModel player) {
    playerManager.addOtherPlayer(
      player.id,
      Vector2(player.positionX.toDouble(), player.positionY.toDouble()),
    );
  }

  void _updatePlayerPosition(PlayerModel player) {
    playerManager.updatePlayerPosition(
      player.id,
      Vector2(player.positionX.toDouble(), player.positionY.toDouble()),
    );
  }

  void addOtherPlayer(String id, Vector2 initialPosition) {
    playerManager.addOtherPlayer(id, initialPosition);
  }

  void removePlayer(String id) {
    playerManager.removePlayer(id);
  }

  void updatePlayerPosition(String id, Vector2 newPosition) {
    playerManager.updatePlayerPosition(id, newPosition);
  }

  void update(double dt) {
    playerManager.update(dt);
  }
}

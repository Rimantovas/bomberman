import 'dart:async';

import 'package:bomberman/game/map/game_map.dart';
import 'package:bomberman/game/movement/keyboard_handler.dart';
import 'package:bomberman/game/player/player.dart';
import 'package:bomberman/game/player/player_manager.dart';
import 'package:bomberman/src/player/bloc/player_manager_bloc.dart';
import 'package:bomberman/src/player/models/player.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<String> asciiMap = [
  "###############",
  "#P           P#",
  "# D D D D D D #",
  "#  ###   ###  #",
  "# D D D D D D #",
  "#  ###   ###  #",
  "# D D D D D D #",
  "#  ###   ###  #",
  "# D D D D D D #",
  "#P           P#",
  "###############",
];

class BombermanGame extends FlameGame
    with KeyboardEvents, HasCollisionDetection {
  BombermanGame({
    required this.playerId,
    required this.sessionId,
    required this.initialPlayers,
  }) {
    playerManagerBloc = PlayerManagerBloc(playerId);

    add(FlameBlocProvider<PlayerManagerBloc, PlayerManagerState>.value(
      value: playerManagerBloc,
      children: [
        FlameBlocListener<PlayerManagerBloc, PlayerManagerState>(
          onNewState: (state) {
            print('other players: ${state.otherPlayers.length}');
            // Update game state based on other players
            updateOtherPlayers(state.otherPlayers);
          },
        ),
      ],
    ));
    playerManagerBloc.startListening(initialPlayers);
  }

  final String playerId;
  final String sessionId;
  final List<PlayerModel> initialPlayers;
  late final PlayerManagerBloc playerManagerBloc;

  late final PlayerManager playerManager;
  late final GameMap gameMap;
  late final AppKeyboardHandler keyboardHandler;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await initializeGame(playerId);
    await playerManager.waitForPlayersToLoad();
  }

  Future<void> initializeGame(String myPlayerId) async {
    gameMap = GameMap(asciiMap: asciiMap);
    gameMap.init();
    await add(gameMap);

    playerManager = PlayerManager();
    await add(playerManager);

    final myPlayer = Player(
      id: myPlayerId,
      position: Vector2(32, 32),
    );
    await playerManager.setMyPlayer(myPlayer);

    keyboardHandler = AppKeyboardHandler(myPlayer);
  }

  @override
  void update(double dt) {
    super.update(dt);
    playerManager.update(dt);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final command = keyboardHandler.handleKeyEvent(event);
    if (command != null) {
      command.execute(playerManager.myPlayer);
      return KeyEventResult.handled;
    }
    return KeyEventResult.handled;
  }

  void updateOtherPlayers(List<PlayerModel> otherPlayers) {
    // Update other players in the game
    for (final player in otherPlayers) {
      if (playerManager.getPlayer(player.id) == null) {
        playerManager.addOtherPlayer(player.id,
            Vector2(player.positionX.toDouble(), player.positionY.toDouble()));
      } else {
        playerManager.updatePlayerPosition(player.id,
            Vector2(player.positionX.toDouble(), player.positionY.toDouble()));
      }
    }

    playerManager.removePlayersNotIn(otherPlayers.map((p) => p.id).toList());
  }

  // Method to add other players when they join
  void addOtherPlayer(String id, Vector2 initialPosition) {
    playerManager.addOtherPlayer(id, initialPosition);
  }

  // Method to remove a player when they leave
  void removePlayer(String id) {
    playerManager.removePlayer(id);
  }

  // Method to update other player's position
  void updatePlayerPosition(String id, Vector2 newPosition) {
    playerManager.updatePlayerPosition(id, newPosition);
  }

  void updateMyPosition(Vector2 newPosition) {
    playerManagerBloc.updateMyPosition(newPosition);
  }
}

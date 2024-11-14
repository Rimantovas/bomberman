import 'dart:async';

import 'package:bomberman/enums/game_theme.dart';
import 'package:bomberman/game/facade/game_facade.dart';
import 'package:bomberman/game/map/game_map.dart';
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
    gameFacade = GameFacade();

    add(FlameBlocProvider<PlayerManagerBloc, PlayerManagerState>.value(
      value: playerManagerBloc,
      children: [
        FlameBlocListener<PlayerManagerBloc, PlayerManagerState>(
          onNewState: (state) {
            print('other players: ${state.otherPlayers.length}');
            gameFacade.updatePlayers(state.otherPlayers);
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
  late final GameFacade gameFacade;

  GameMap get gameMap => gameFacade.gameMap;
  PlayerManager get playerManager => gameFacade.playerManager;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await initializeGame();
    await gameFacade.playerManager.waitForPlayersToLoad();
  }

  Future<void> initializeGame() async {
    await gameFacade.initializeGame(
      asciiMap: asciiMap,
      playerId: playerId,
      theme: GameTheme.retro,
      game: this,
    );
    print('2 ${gameFacade.gameMap.children.length}');

    await add(gameFacade.gameMap);
    await add(gameFacade.playerManager);

    print('3 ${children.length}');
  }

  @override
  void update(double dt) {
    super.update(dt);
    gameFacade.update(dt);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final command =
        gameFacade.keyboardHandler.handleKeyEvent(event, keysPressed);
    if (command != null) {
      command.execute(gameFacade.playerManager.myPlayer);
      return KeyEventResult.handled;
    }
    return KeyEventResult.handled;
  }

  void updateMyPosition(Vector2 newPosition) {
    playerManagerBloc.updateMyPosition(newPosition);
  }
}

import 'package:bomberman/game/app_asset.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/bomberman_game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bomberman Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/${AppAsset.rockWall}',
              repeat: ImageRepeat.repeat,
              fit: BoxFit.none,
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AspectRatio(
                aspectRatio:
                    BombermanGame.gameSize.x / BombermanGame.gameSize.y,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: BombermanGame.gameSize.x,
                    height: BombermanGame.gameSize.y,
                    child: GameWidget(
                      game: BombermanGame(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

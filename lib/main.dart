import 'package:bomberman/firebase_options.dart';
import 'package:bomberman/game/map/game_map.dart';
import 'package:bomberman/menu/menu_screen.dart';
import 'package:bomberman/src/session/bloc/session_bloc.dart';
import 'package:bomberman/utils/app_asset.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'game.dart';

late final Dio dio;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3000',
    ),
  );
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
      home: const MainMenu(),
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
                aspectRatio: GameMap.gameSize.x / GameMap.gameSize.y,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: GameMap.gameSize.x,
                    height: GameMap.gameSize.y,
                    child: BlocProvider(
                      create: (context) => SessionBloc()..joinSession(),
                      child: BlocBuilder<SessionBloc, SessionState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return GameWidget(
                            game: BombermanGame(
                              playerId: state.playerId!,
                              sessionId: state.sessionId!,
                            ),
                          );
                        },
                      ),
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

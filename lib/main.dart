import 'package:bomberman/game/map/game_map.dart';
import 'package:bomberman/menu/bloc/game_settings_bloc.dart';
import 'package:bomberman/menu/menu_screen.dart';
import 'package:bomberman/src/session/bloc/session_bloc.dart';
import 'package:bomberman/utils/app_asset.dart';
import 'package:bomberman/utils/http/http_client.dart';
import 'package:bomberman/utils/http/http_package_client.dart';
import 'package:bomberman/utils/logger.dart';
import 'package:bomberman/utils/logger/logger_config.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'game.dart';

late final HttpClient httpClient;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  httpClient = HttpPackageClient(baseUrl: 'http://localhost:3000');
  // httpClient = DioClient(
  //   baseUrl: 'http://localhost:3000',
  // );
  Log.initialize(
    const LoggerConfig(
      enableFileLogging: true,
      enableCrashReporting: true,
      enableAlerts: true,
      crashEndpoint: 'https://api.example.com/crash',
      alertsEndpoint: 'https://api.example.com/alerts',
      logFileName: 'game.log',
    ),
  );
  Log.instance.log('Firebase initialized');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    GetIt.I.registerSingleton<GameSettingsBloc>(GameSettingsBloc());
  }

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
                              playerId: state.playerId ?? '',
                              sessionId: state.sessionId ?? '',
                              initialPlayers: state.initialPlayers,
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

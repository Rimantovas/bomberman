import 'package:bomberman/audio/audio_manager.dart';
import 'package:bomberman/main.dart';
import 'package:bomberman/menu/bloc/game_settings_bloc.dart';
import 'package:bomberman/menu/screens/settings_screen.dart';
import 'package:bomberman/utils/app_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final AudioManager _audioManager = AudioManager();

  @override
  void initState() {
    super.initState();
    _loadBackgroundMusic();
  }

  Future<void> _loadBackgroundMusic() async {
    await _audioManager.loadAudio('assets/audio/background_music.mp3');
    await _audioManager.play();
  }

  @override
  void dispose() {
    _audioManager.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameSettingsBloc, GameSettingsState>(
      bloc: GetIt.I.get<GameSettingsBloc>(),
      listener: (context, state) {
        print('GameSettingsState: $state');

        _audioManager.setVolume(state.volume);
        if (state.isMuted) {
          _audioManager.mute();
        } else {
          _audioManager.unmute();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAsset.menuBackground(state.theme)),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  const Text(
                    'Bomberman',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  _BuildButton(
                    text: 'Play',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GameScreen()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _BuildButton(
                    text: 'Settings',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsScreen()),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BuildButton extends StatefulWidget {
  const _BuildButton({super.key, required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  State<_BuildButton> createState() => __BuildButtonState();
}

class __BuildButtonState extends State<_BuildButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => setState(() => isHovered = true),
      onExit: (event) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Text(
          widget.text,
          style: TextStyle(
            color: isHovered ? Colors.yellow : Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
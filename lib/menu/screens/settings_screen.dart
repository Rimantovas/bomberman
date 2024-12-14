import 'dart:async';

import 'package:bomberman/enums/game_theme.dart';
import 'package:bomberman/menu/bloc/edit_settings_bloc.dart';
import 'package:bomberman/menu/bloc/game_settings_bloc.dart';
import 'package:bomberman/utils/app_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditSettingsBloc(GetIt.I.get<GameSettingsBloc>()),
      child: BlocBuilder<EditSettingsBloc, EditSettingsState>(
        builder: (context, state) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppAsset.menuBackground(state.theme)),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Settings',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // Balance for back button
                    ],
                  ),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.all(24),
                    constraints: const BoxConstraints(maxWidth: 600),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Theme',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: DropdownButton<GameTheme>(
                            value: state.theme,
                            dropdownColor: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(4),
                            isExpanded: true,
                            underline: const SizedBox(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            items: GameTheme.values.map((theme) {
                              return DropdownMenuItem(
                                value: theme,
                                child: Text(theme.name),
                              );
                            }).toList(),
                            onChanged: (theme) {
                              if (theme != null) {
                                context
                                    .read<EditSettingsBloc>()
                                    .setTheme(theme);
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Audio',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.volume_down, color: Colors.white),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.white,
                                  inactiveTrackColor: Colors.white30,
                                  thumbColor: Colors.white,
                                  overlayColor: Colors.white.withOpacity(0.3),
                                ),
                                child: Slider(
                                  value: 0.5, // Placeholder value
                                  onChanged: (value) {
                                    // Audio logic will be added later
                                  },
                                ),
                              ),
                            ),
                            const Icon(Icons.volume_up, color: Colors.white),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            context.read<EditSettingsBloc>().saveSettings();
                            _showRevertDialog(context);
                          },
                          child: const Text(
                            'Save Settings',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showRevertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<EditSettingsBloc>(),
          child: BlocListener<EditSettingsBloc, EditSettingsState>(
            listener: (context, state) {},
            child: RevertDialog(
              onRevert: () {
                context.read<EditSettingsBloc>().revertSettings();
                Navigator.of(dialogContext).pop();
              },
              onKeepChanges: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ),
        );
      },
    );
  }
}

class RevertDialog extends StatefulWidget {
  const RevertDialog(
      {super.key, required this.onRevert, required this.onKeepChanges});

  final VoidCallback onRevert;
  final VoidCallback onKeepChanges;

  @override
  State<RevertDialog> createState() => _RevertDialogState();
}

class _RevertDialogState extends State<RevertDialog> {
  int seconds = 5;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          seconds--;
        });
        if (seconds <= 0) {
          widget.onRevert();
          timer.cancel();
        }
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Settings Saved',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You have $seconds seconds to revert the changes if needed.',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    widget.onRevert();
                  },
                  child: const Text(
                    'Revert',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.onKeepChanges();
                  },
                  child: const Text(
                    'Keep Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

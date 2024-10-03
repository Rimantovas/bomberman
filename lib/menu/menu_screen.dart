import 'package:bomberman/main.dart';
import 'package:bomberman/utils/app_asset.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAsset.menuBackground),
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
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
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

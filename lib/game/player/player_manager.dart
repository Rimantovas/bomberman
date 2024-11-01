import 'package:bomberman/game/player/player.dart';
import 'package:bomberman/game/rendering/color_scheme.dart';
import 'package:flame/components.dart';

class PlayerManager extends Component {
  final Map<String, Player> _otherPlayers = {};
  late Player myPlayer;
  bool _isLoaded = false;

  Future<void> setMyPlayer(Player player) async {
    myPlayer = player;
    await add(myPlayer);
    _isLoaded = true;
  }

  Future<void> addOtherPlayer(String id, Vector2 initialPosition) async {
    final player = Player(
      id: id,
      position: initialPosition,
      colorImplementor: BlueColorImplementor(),
    );
    _otherPlayers[id] = player;
    await add(player);
  }

  Player? getPlayer(String id) {
    return _otherPlayers[id];
  }

  void removePlayersNotIn(List<String> ids) {
    for (final id in _otherPlayers.keys) {
      if (!ids.contains(id)) {
        removePlayer(id);
      }
    }
  }

  void removePlayer(String id) {
    final player = _otherPlayers.remove(id);
    if (player != null) {
      remove(player);
    }
  }

  void updatePlayerPosition(String id, Vector2 newPosition) {
    final player = _otherPlayers[id];
    if (player != null) {
      player.position = newPosition;
    }
  }

  @override
  void update(double dt) {
    if (!_isLoaded) return;
    super.update(dt);
    myPlayer.update(dt);
    for (final player in _otherPlayers.values) {
      player.update(dt);
    }
  }

  Future<void> waitForPlayersToLoad() async {
    await Future.wait([
      myPlayer.loaded,
      ..._otherPlayers.values.map((player) => player.loaded),
    ]);
  }
}

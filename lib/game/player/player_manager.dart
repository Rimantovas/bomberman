import 'package:bomberman/game/player/player.dart';
import 'package:flame/components.dart';

class PlayerManager extends Component {
  final Map<String, Player> _otherPlayers = {};
  late Player myPlayer;

  void setMyPlayer(Player player) {
    myPlayer = player;
    add(myPlayer);
  }

  void addOtherPlayer(String id, Vector2 initialPosition) {
    final player = Player(
      id: id,
      position: initialPosition,
      // isMyPlayer: false,
    );
    _otherPlayers[id] = player;
    add(player);
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
    super.update(dt);
    // Update my player
    myPlayer.update(dt);
    // Update other players if needed
    for (final player in _otherPlayers.values) {
      player.update(dt);
    }
  }
}

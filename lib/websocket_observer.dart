import 'package:bomberman/src/player/models/player.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

// Define the observer interface
abstract class WebSocketObserver {
  void onPlayerMoved(String id, int positionX, int positionY);
  void onPlayerJoined(PlayerModel player);
  void onPlayerLeft(String id);
}

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;

  final List<WebSocketObserver> _observers = [];
  late io.Socket _socket;

  WebSocketService._internal() {
    _initializeSocket();
  }

  void _initializeSocket() {
    _socket = io.io('ws://172.20.10.10:7777',
        io.OptionBuilder().setTransports(['websocket']).build());

    _socket.on('player_moved', (data) {
      final json = data as Map<String, dynamic>;
      print('XXX $data');
      _notifyPlayerMoved(
        json['id'],
        json['position_x'],
        json['position_y'],
      );
    });

    _socket.on('player_joined', (data) {
      final player = PlayerModelMapper.fromMap(data);
      _notifyPlayerJoined(player);
    });

    _socket.on('player_left', (data) {
      final id = (data as Map<String, dynamic>)['id'];
      _notifyPlayerLeft(id);
    });
  }

  void addObserver(WebSocketObserver observer) {
    _observers.add(observer);
  }

  void removeObserver(WebSocketObserver observer) {
    _observers.remove(observer);
  }

  void _notifyPlayerMoved(String id, int positionX, int positionY) {
    for (final observer in _observers) {
      observer.onPlayerMoved(id, positionX, positionY);
    }
  }

  void _notifyPlayerJoined(PlayerModel player) {
    for (final observer in _observers) {
      observer.onPlayerJoined(player);
    }
  }

  void _notifyPlayerLeft(String id) {
    for (final observer in _observers) {
      observer.onPlayerLeft(id);
    }
  }
}

import 'package:bomberman/game/board_object/board_object.dart';

class MapClass {
  final List<BoardObject> _objects;

  MapClass() : _objects = [];

  void add(BoardObject object) {
    _objects.add(object);
  }

  void addAll(List<BoardObject> objects) {
    _objects.addAll(objects);
  }

  List<BoardObject> get objects => _objects;
}

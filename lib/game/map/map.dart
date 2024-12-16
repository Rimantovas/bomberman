import 'package:bomberman/game/board_object/board_object.dart';

//* [PATTERN] Implements Iterator Pattern
class MapClass implements Iterator<BoardObject> {
  final List<BoardObject> _objects;

  MapClass() : _objects = [];

  int _currentIndex = -1;

  void add(BoardObject object) {
    _objects.add(object);
  }

  void addAll(List<BoardObject> objects) {
    _objects.addAll(objects);
  }

  // List<BoardObject> get objects => _objects;

  @override
  get current => _objects[_currentIndex];

  @override
  bool moveNext() {
    if (_currentIndex < _objects.length - 1) {
      _currentIndex++;
      return true;
    }
    return false;
  }

  void resetIterator() {
    _currentIndex = -1;
  }
}

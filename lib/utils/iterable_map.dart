//* [PATTERN] Implements Iterator Pattern
class MapIterator implements Iterator {
  final Map _map;

  MapIterator() : _map = {};

  int _currentIndex = -1;

  void add(key, value) {
    _map[key] = value;
  }

  void addAll(Map map) {
    _map.addAll(map);
  }

  get data => _map;

  @override
  get current => _map.values.elementAt(_currentIndex);

  @override
  bool moveNext() {
    if (_currentIndex < _map.length - 1) {
      _currentIndex++;
      return true;
    }
    return false;
  }
}

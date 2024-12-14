import 'package:bomberman/menu/memento/settings_memento.dart';

//* MEMENTO PATTERN
class SettingsCaretaker {
  final List<SettingsMemento> _mementos = [];
  int _currentIndex = -1;
  static const int _maxHistorySize = 10;

  void saveMemento(SettingsMemento memento) {
    // Limit history size
    if (_mementos.length >= _maxHistorySize) {
      _mementos.removeAt(0);
      _currentIndex--;
    }

    // Remove any future states if we're not at the latest state
    if (_currentIndex < _mementos.length - 1) {
      _mementos.removeRange(_currentIndex + 1, _mementos.length);
    }

    _mementos.add(memento);
    _currentIndex = _mementos.length - 1;
  }

  SettingsMemento? undo() {
    if (_currentIndex > 0) {
      _currentIndex--;
      return _mementos[_currentIndex];
    }
    return null;
  }

  bool get canUndo => _currentIndex > 0;
}

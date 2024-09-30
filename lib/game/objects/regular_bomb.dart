import 'bomb.dart';

class RegularBomb extends Bomb {
  RegularBomb({required super.position})
      : super(
          strength: 2,
          branching: 1,
          explosionDelay: 3.0,
        );
}

class AppAsset {
  static String character(String type, String direction) =>
      'character/$type-$direction.png';
  static String item(String name) => 'items/$name.png';
  static String terrain(String name) => 'terrain/$name.png';

  static String playerIdleBack = character('idle', 'back');
  static String playerIdleFront = character('idle', 'front');
  static String playerIdleLeft = character('idle', 'left');
  static String playerIdleRight = character('idle', 'right');
  static String playerWalkBack = character('walk', 'back');
  static String playerWalkFront = character('walk', 'front');
  static String playerWalkLeft = character('walk', 'left');
  static String playerWalkRight = character('walk', 'right');
  static String playerDeathFront = character('death', 'front');

  static String bombDynamite = item('dynamite');
  static String destroyableBox = item('box');
  static String bedrockWall = terrain('wall');
  static String rockWall = terrain('rock');

  static String menuBackground = 'assets/images/menu_bg.png';
}
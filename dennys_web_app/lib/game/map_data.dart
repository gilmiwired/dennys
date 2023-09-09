
import 'package:flame/game.dart';
import 'package:flame/extensions.dart';
import 'package:flame/components.dart';
import 'package:flame/src/extensions/vector2.dart';

//wall
final Map<int, Vector2> spriteCoordinates = {
  -1 :Vector2(0, 0),
  0: Vector2(0, 0),  // none_tile
  1: Vector2(5, 2),  // TopWall
  2: Vector2(4, 2),  // TopEdge

  3: Vector2(1, 1),  // TopLeftEdge
  4: Vector2(1, 4),  // TopRightEdge

  5: Vector2(2, 1),  // TopLeftWall
  6: Vector2(2, 4),  // TopRightWall


  7: Vector2(3, 5),  // LeftEdge
  8: Vector2(3, 4),  // RightEdge


  9: Vector2(6, 1),  // DownLeftWall
  10: Vector2(6, 4), // DownRightWall

  11: Vector2(7, 1), // DownLeftEdge
  12: Vector2(7, 4), // DownRightEdge

  13: Vector2(5, 2), // DownEdge
  14: Vector2(4, 2), // DownWall
  15: Vector2(0, 0), // DownWall

  16: Vector2(6, 1),
  17: Vector2(7, 1),
  18: Vector2(1, 1),
  19: Vector2(2, 1),

  20: Vector2(2, 4),
  21: Vector2(1, 4),
  22: Vector2(6, 4),
  23: Vector2(7, 4),
  24: Vector2(0,0),
};

final Map<int, Vector2> spriteCoordinatesFloor = {
  -1 :Vector2(15, 2),
  0: Vector2(0, 0),  // none_tile

  1: Vector2(15, 2),  // TopWall
  2: Vector2(14, 2),  // TopEdge

  3: Vector2(14, 1),  // TopLeftEdge
  4: Vector2(14, 4),  // TopRightEdge

  5: Vector2(15, 1),  // TopLeftWall
  6: Vector2(15, 4),  // TopRightWall


  7: Vector2(15, 1),  // LeftEdge
  8: Vector2(15, 4),  // RightEdge


  9: Vector2(16, 5),  // DownLeftWall
  10: Vector2(16, 5), // DownRightWall

  11: Vector2(0, 0), // DownLeftEdge
  12: Vector2(0, 0), // DownRightEdge

  13: Vector2(0, 0), // DownEdge
  14: Vector2(16, 5), // DownWall
  15: Vector2(15, 2), // DownWall

  16: Vector2(15, 2),
  17: Vector2(15, 2),
  18: Vector2(17, 5),//

  19: Vector2(15, 4),
  20: Vector2(15, 1),
  21: Vector2(15, 1),
  22: Vector2(15, 2),//defwall
  23: Vector2(15,2),
  24: Vector2(15,2),

};

final List<List<int>> floorData = [
  [3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4],
  [5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 6],
  [7, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 8],
  [7, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 8],
  [7, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 8],
  [7, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 8],
  [7, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 8],
  [9, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 10],
  [11, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 12],
];
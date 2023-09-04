
import 'package:flame/game.dart';
import 'package:flame/extensions.dart';
import 'package:flame/components.dart';
import 'package:flame/src/extensions/vector2.dart';

//wall
final Map<int, Vector2> spriteCoordinates = {
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
};

final Map<int, Vector2> spriteCoordinatesFloor = {
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
};

final List<List<int>> mapData = [
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
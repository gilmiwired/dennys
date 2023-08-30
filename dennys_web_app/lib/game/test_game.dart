import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'dart:ui';
import 'package:flame/extensions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/src/extensions/vector2.dart';

class BuildGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final game = MyGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interactive Map Example'),
      ),
      body: InteractiveViewer(
        maxScale: 2.0,
        minScale: 0.5,
        child: GameWidget(game: game),
      ),
    );
  }
}

class MyGame extends Game {
  final tileSize = 16.0;
  final List<List<int>> mapData;
  late SpriteSheet spriteSheet;

  MyGame() : mapData = [
    [3, 2, 2, 2, 2, 4],
    [5, 1, 1, 1, 1, 6],
    [7, 0, 0, 0, 0, 8],
    [7, 0, 0, 0, 0, 8],
    [9, 2, 2, 2, 2, 10],
    [11, 1, 1, 1, 1, 12],
  ];
  final Map<int, Vector2> spriteCoordinates = {
    0: Vector2(0, 0),  // tile
    1: Vector2(5, 2),  // wall
    2: Vector2(4, 2),  // Edge

    3: Vector2(1, 1),  // TopLeftEdge
    4: Vector2(1, 4),  // TopRightEdge

    5: Vector2(2, 1),  // TopLeftwall
    6: Vector2(2, 4),  // TopRightWall


    7: Vector2(3, 1),  // LeftEdge
    8: Vector2(3, 4),  // RightEdge


    9: Vector2(6, 1),  // DownLeftwall
    10: Vector2(6, 4), // DownRightWall

    11: Vector2(7, 1), // DownLeftEdge
    12: Vector2(7, 4), // CownRightEdge
  };


  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load("dungeon_.png");
    spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(16, 16),
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(50, 50);
    canvas.scale(0.8);

    for (int y = 0; y < mapData.length; y++) {
      for (int x = 0; x < mapData[y].length; x++) {
        final tile = mapData[y][x];
        drawTile(canvas, x, y, tile);
      }
    }

    canvas.restore();
  }

  void drawTile(Canvas canvas, int x, int y, int tileType) {
    final coordinates = spriteCoordinates[tileType] ?? Vector2.zero();
    final sprite = spriteSheet.getSprite(coordinates.x.toInt(), coordinates.y.toInt());
    final dx = x * tileSize;
    final dy = y * tileSize;
    sprite.render(
      canvas,
      position: Vector2(dx.toDouble(), dy.toDouble()),
      size: Vector2(tileSize, tileSize),
    );
  }

  @override
  void update(double dt) {
    // Game logic (omitted here)
  }
}
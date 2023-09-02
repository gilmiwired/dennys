import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'dart:ui';
import 'package:flame/extensions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/src/extensions/vector2.dart';
import 'package:dennys_web_app/game/map_data.dart';


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
  late SpriteSheet playerSpriteSheet;

  MyGame() : mapData = [
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


  final Vector2 playerPosition = Vector2(3 * 16.0, 3 * 16.0); // 3, 7の位置にプレイヤーを置く
  final List<Vector2> playerSprites = [
    Vector2(1, 0),
    Vector2(3, 7),
    Vector2(5, 7),
    Vector2(7, 7),
  ]; // プレイヤーの4つのスプライト座標


  int currentSpriteIndex = 0; // 現在のスプライトのインデックス
  double elapsedTime = 0.0; // 経過時間


  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load("dungeon_.png");
    spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(16, 16),
    );

    final playerImage = await Flame.images.load('knight_.png');
    playerSpriteSheet = SpriteSheet(
      image: playerImage,
      srcSize: Vector2(8, 8),
    );
    /*
    final playerImage = await Flame.images.load('knight_.png');
    playerSpriteSheet = SpriteSheet(
      image: playerImage,
      srcSize: Vector2(8, 8),
    );*/
  }

  @override
  void render(Canvas canvas) {
    //canvas.save();
    canvas.translate(50, 50);
    canvas.scale(0.8);

    // 床レイヤーを描画
    for (int y = 0; y < mapData.length; y++) {
      for (int x = 0; x < mapData[y].length; x++) {
        final floorTile = mapData[y][x];
        drawTile(canvas, x, y+1, floorTile, spriteCoordinatesFloor);
      }
    }
    for (int y = 0; y < mapData.length; y++) {
      for (int x = 0; x < mapData[y].length; x++) {
        final floorTile = mapData[y][x];
        drawTile(canvas, x, y+24, floorTile, spriteCoordinatesFloor);
      }
    }

    // 壁や他のオブジェクトのレイヤーを描画
    for (int y = 0; y < mapData.length; y++) {
      for (int x = 0; x < mapData[y].length; x++) {
        final tile = mapData[y][x];
        drawTile(canvas, x, y, tile, spriteCoordinates);
      }
    }

    // 中央の座標を計算（例として）
    int centerX = (mapData[0].length ~/ 2);
    int centerY = (mapData.length ~/ 2);

    // テキストのスタイルを設定
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'Center',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();

    // テキストを描画（マップの中心に）
    textPainter.paint(
      canvas,
      Offset(centerX * tileSize.toDouble(), centerY * tileSize.toDouble()),
    );


    /*
    // 0の場合のプレイヤー描画処理
    double dx = 1 * tileSize; // x座標（0の場合）
    double dy = 1 * tileSize; // y座標（0の場合）

    // スプライト座標（ここでは例として (0, 0)）
    int spriteX = 1;
    int spriteY = 0;


    final sprite = playerSpriteSheet.getSprite(spriteX , spriteY);
    sprite.render(
      canvas,
      position: Vector2(
          dx.toDouble() + (0 * tileSize),
          dy.toDouble() + (0 * tileSize)
      ),
      size: Vector2(tileSize, tileSize),
    );


    final sprite2 = playerSpriteSheet.getSprite(spriteX+1 , spriteY);
    sprite2.render(
      canvas,
      position: Vector2(
          dx.toDouble() + (0 * tileSize),
          dy.toDouble() + (1 * tileSize)
      ),
      size: Vector2(tileSize, tileSize),
    );


    final sprite3 = playerSpriteSheet.getSprite(spriteX , spriteY+1);
    sprite3.render(
      canvas,
      position: Vector2(
          dx.toDouble() + (1 * tileSize),
          dy.toDouble() + (0 * tileSize)
      ),
      size: Vector2(tileSize, tileSize),
    );


    final sprite4 = playerSpriteSheet.getSprite(spriteX+1 , spriteY+1);
    sprite4.render(
      canvas,
      position: Vector2(
          dx.toDouble() + (1 * tileSize),
          dy.toDouble() + (1 * tileSize)
      ),
      size: Vector2(tileSize, tileSize),
    );

    final sprite5 = playerSpriteSheet.getSprite(spriteX , spriteY+2);
    sprite5.render(
      canvas,
      position: Vector2(
          dx.toDouble() + (2 * tileSize),
          dy.toDouble() + (0 * tileSize)
      ),
      size: Vector2(tileSize, tileSize),
    );


    final sprite6 = playerSpriteSheet.getSprite(spriteX+1 , spriteY+2);
    sprite6.render(
      canvas,
      position: Vector2(
          dx.toDouble() + (2 * tileSize),
          dy.toDouble() + (1 * tileSize)
      ),
      size: Vector2(tileSize, tileSize),
    );
  */

    // renderメソッド内で
    //drawPlayer(canvas, playerPosition, playerSprites[0],16,playerSpriteSheet); // プレイヤー1のスプライトを描画
    drawPlayer(canvas, playerPosition, playerSprites[0], 16, playerSpriteSheet);
    //canvas.restore();
  }

  void drawTile(Canvas canvas, int x, int y, int tileType, Map<int, Vector2> coordinates) {
    final coord = coordinates[tileType] ?? Vector2.zero();
    final sprite = spriteSheet.getSprite(coord.x.toInt(), coord.y.toInt());
    final dx = x * tileSize;
    final dy = y * tileSize;
    sprite.render(
      canvas,
      position: Vector2(dx.toDouble(), dy.toDouble()),
      size: Vector2(tileSize, tileSize),
    );
  }


  void drawPlayer(Canvas canvas, Vector2 d, Vector2 sprite, double tileSize, SpriteSheet playerSpriteSheet) {
    for (int y = 0; y < 3; y++) {
      for (int x = 0; x < 3; x++) {
        final spriteImg = playerSpriteSheet.getSprite(sprite.x.toInt() + y, sprite.y.toInt() + x);
        spriteImg.render(
          canvas,
          position: Vector2(
            d.x.toDouble() + (x * tileSize),
            d.y.toDouble() + (y * tileSize),
          ),
          size: Vector2(tileSize, tileSize),
        );
      }
    }
  }






  @override
  void update(double dt) {
    // 経過時間にdt（デルタタイム）を加算
    elapsedTime += dt;

    // 0.2秒以上経過した場合、スプライトを更新
    if (elapsedTime >= 0.2) {
      currentSpriteIndex = (currentSpriteIndex + 1) % playerSprites.length;
      elapsedTime = 0.0; // 経過時間をリセット
    }
    // Game logic (omitted here)
  }
}
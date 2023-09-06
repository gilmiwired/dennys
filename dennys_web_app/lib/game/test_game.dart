import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'dart:ui';
import 'package:flame/extensions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/src/extensions/vector2.dart';
import 'package:dennys_web_app/game/map_data.dart';
import 'package:dennys_web_app/global_setting/global_tree.dart';
import 'package:dennys_web_app/main.dart';
import 'dart:math';

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
  late List<List<int>> mapData;
  late SpriteSheet spriteSheet;
  late SpriteSheet playerSpriteSheet;

  //MyGame(mapData);
  MyGame() {
    mapData = generateMapData();
  }
  /*[
    [3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4],
    [5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 6],
    [7, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 8],
    [7, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 8],
    [7, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 8],
    [7, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 8],
    [7, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 8],
    [9, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 10],
    [11, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 12],
  ];*/

  List<List<int>> generateMapData() {
    GlobalTree myTree = GlobalTree.instance;
    late List<List<int>> dynamicMap = generateZeroMatrix(myTree.maxMapHeight+20, myTree.maxMapWidth+20);

    print("Max Height: ${myTree.maxMapHeight}, Max Width: ${myTree.maxMapWidth}"); // Debug
    print("Matrix dimensions: ${dynamicMap.length}x${dynamicMap[0].length}"); // Debug

    myTree.nodeList.forEach((key, node) {

      print("key: ${key}");
      print("Checking node with x: ${node.x}, y: ${node.y}"); // Debug

      if (node.x <= myTree.maxMapHeight && node.y <= myTree.maxMapWidth) {
        print("Marking node with x: ${node.x}, y: ${node.y}"); // Debug

        for (int dx = 0; dx < floorData.length; ++dx) {
          for (int dy = 0; dy < floorData[dx].length; ++dy) {
            int newY = node.y + dx; // Y is for rows
            int newX = node.x + dy; // X is for columns
            //print("new node with newX: $newX, newY: $newY dx $dx dy $dy ${floorData[dx][dy]}"); // Debug


            // Make sure we're not going out of bounds
            if (newY < dynamicMap.length && newX < dynamicMap[0].length) {
              dynamicMap[newY][newX] += floorData[dx][dy];
            }
          }
        }

        // Initialize variables to hold the min and max y values and corresponding nodes
        int? minY;
        Node? minNode;
        int? maxY;
        Node? maxNode;

        // Loop through each child and update min and max y values and nodes
        if (node.children != null) {
          node.children!.forEach((child) {
            if (minY== null || child.y < minY!) {
              minY = child.y;
              minNode = child;
            }
            if (maxY == null || child.y > maxY!) {
              maxY = child.y;
              maxNode = child;
            }
          });
        }

        // Compute the length in y direction spanned by the children
        if (minY != null && maxY != null) {
          int yLength = maxY! - minY!;
          print("yLength spanned by children of node with key $key: $yLength");
          print("Min node: ${minNode?.title}, Max node: ${maxNode?.title}");
        } else {
          print("Node with key $key has no children, so yLength is undefined.");
        }


        print('${node.rank} maxRank ${myTree.maxRank}');
        //dynamicMap[node.y+4][node.x]=1;

        if(node.rank != myTree.maxRank+1 && node.countChildren()!=0){

          int edgeLength = 0;
          for(int i = 0; i<(myTree.horizontalSpacing ~/ 2);i++){
            dynamicMap[node.y+4][node.x-i] = -1;
          }
          for(int i = minNode!.y+4; i<maxNode!.y+4; i++){
            dynamicMap[i][node.x-(myTree.horizontalSpacing~/2)]=-1;
          }
          node.children!.forEach((child) {
            for(int i=0;i<(myTree.horizontalSpacing ~/ 2);i++){
              dynamicMap[child.y+4][child.x+myTree.nodeWidth+(myTree.horizontalSpacing~/2)-1-i] = -1;
            }
          });
        }
      }
    });



    /*
    myTree.nodeList.forEach((key, node) {
      if (node.children != null && node.children!.isNotEmpty) {
        int adjustedX = node.x - (myTree.horizontalSpacing ~/ 2);
        int adjustedY = node.y - 5;
        print("node title :${node.title} node x: ${node.x}, node y: ${node.y}");
        print("Adjusted X: $adjustedX, Adjusted Y: $adjustedY");
        print ("${myTree.horizontalSpacing ~/ 2}");

        dynamicMap[adjustedY][adjustedX] = 1;
      }
    });
*/



    return dynamicMap;
  }


  List<List<int>> generateZeroMatrix(int rows, int cols) {
    return List.generate(rows, (i) => List.generate(cols, (j) => 0));
  }




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

    /*
    for (int y = 0; y < mapData.length; y++) {
      for (int x = 0; x < mapData[y].length; x++) {
        final floorTile = mapData[y][x];
        drawTile(canvas, x, y+24, floorTile, spriteCoordinatesFloor);
      }
    }
    */
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
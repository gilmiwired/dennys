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
  GlobalTree myTree = GlobalTree.instance;
  late List<List<int>> dynamicMap = generateZeroMatrix(myTree.maxMapHeight+20, myTree.maxMapWidth+20);

  //MyGame(mapData);
  MyGame() {
    mapData = generateMapData();
  }


  List<List<int>> generateMapData() {
    print("Max Height: ${myTree.maxMapHeight}, Max Width: ${myTree.maxMapWidth}");
    print("Matrix dimensions: ${dynamicMap.length}x${dynamicMap[0].length}");

    myTree.nodeList.forEach((key, node) {
      print("Checking node with x: ${node.x}, y: ${node.y}");

      if (node.x <= myTree.maxMapHeight && node.y <= myTree.maxMapWidth) {
        for (int dx = 0; dx < floorData.length; ++dx) {
          for (int dy = 0; dy < floorData[dx].length; ++dy) {
            int newY = node.y + dx;
            int newX = node.x + dy;

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

      }
    });

    List<int> vertical = [2,1,15,14,13];
    List<int> horizontal = [8,15,7];
    List<int> verticalLeft = [16,17,15,18,19];
    List<int> verticalRight = [22,23,15,21,20];


    //エッジ作成
    myTree.nodeList.forEach((key, node) {
      if (node.x <= myTree.maxMapHeight && node.y <= myTree.maxMapWidth) {
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

        if(node.rank != myTree.maxRank+1 && node.countChildren()!=0){
          //左道
          //done
          node.children!.forEach((child) {
            int xLeftEdge = child.y + 2;
            int yLeftEdge = child.x + myTree.nodeWidth + (myTree.horizontalSpacing~/2) - 1;
            int endRight =child.x+myTree.nodeWidth-1;

            for (int j = 0; j < 5; j++) {
              dynamicMap[xLeftEdge + j][yLeftEdge] = 4 + j * 2;
              dynamicMap[xLeftEdge+j][endRight] = verticalLeft[j];
            }
            for(int i = 1; i < (myTree.horizontalSpacing ~/ 2); i++){
              for (int j = 0; j < 5; j++) {
                dynamicMap[xLeftEdge+j][yLeftEdge-i] = vertical[j];
              }
            }
          });
          //縦道
          //done

          int xMiddleEdge = minNode!.y+4;
          int yMiddleEdge = node.x-(myTree.horizontalSpacing~/2);

          dynamicMap[xMiddleEdge].setRange(yMiddleEdge-3, yMiddleEdge, [-1,15,8]);
          dynamicMap[xMiddleEdge+1].setRange(yMiddleEdge-3, yMiddleEdge, [21,15,8]);
          dynamicMap[xMiddleEdge+2].setRange(yMiddleEdge-3, yMiddleEdge, [20,15,8]);

          for(int i = xMiddleEdge+3; i<maxNode!.y+4; i++){
            if(dynamicMap[i][yMiddleEdge-3]==2){

              dynamicMap[i].setRange(yMiddleEdge-3, yMiddleEdge, [22,15,8]);
              dynamicMap[i+1].setRange(yMiddleEdge-3, yMiddleEdge, [23,15,8]);
              if(i+2<maxNode!.y+4) {
                dynamicMap[i + 2].setRange(yMiddleEdge - 3, yMiddleEdge, [24, 15, 8]);
                dynamicMap[i + 3].setRange(yMiddleEdge - 3, yMiddleEdge, [21, 15, 8]);
                dynamicMap[i + 4].setRange(yMiddleEdge - 3, yMiddleEdge, [20, 15, 8]);
                i = i + 4;
              }else{
                i = i + 2;
              }

            }
            else {
              for(int j=0;j<3;j++) {
                dynamicMap[i][yMiddleEdge-j-1] = horizontal[j];
              }
            }
          }
          //~done

          //右道
          for(int j=0;j<5;j++) {
            dynamicMap[node.y+2+j][node.x] = verticalRight[j];
            dynamicMap[node.y+2+j][yMiddleEdge-1] = verticalLeft[j];
          }
          for(int i = 1; i<(myTree.horizontalSpacing ~/ 2) + 1;i++){
            for(int j=0;j<5;j++) {
              dynamicMap[node.y+2+j][node.x-i] = vertical[j];
            }
          }
        }
      }
    });
    return dynamicMap;
  }

  List<List<int>> generateZeroMatrix(int rows, int cols) {
    return List.generate(rows, (i) => List.generate(cols, (j) => 0));
  }

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
    canvas.save();
    canvas.translate(-400, 50);
    canvas.scale(0.8);
    // 床レイヤーを描画
    for (int y = 0; y < mapData.length; y++) {
      for (int x = 0; x < mapData[y].length; x++) {
        final floorTile = mapData[y][x];
        drawTile(canvas, x, y+1, floorTile, spriteCoordinatesFloor);
      }
    }
    // 壁や他のオブジェクトのレイヤーを描画
    for (int y = 0; y < mapData.length; y++) {
      for (int x = 0; x < mapData[y].length; x++) {
        final tile = mapData[y][x];
        drawTile(canvas, x, y, tile, spriteCoordinates);
      }
    }
    drawNodeText(canvas);
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

  // Function to draw text on a specific tile
  void drawText(Canvas canvas, String text, int x, int y) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(color: , fontSize: 12.0),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final offset = Offset(x * tileSize, y * tileSize);
    textPainter.paint(canvas, offset);
  }

  void drawNodeText(Canvas canvas){
    myTree.nodeList.forEach((key, node){
      drawText(canvas, node.title, node.x+2, node.y+4);
    });
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
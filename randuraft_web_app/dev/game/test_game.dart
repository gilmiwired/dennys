// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/extensions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:randuraft_web_app/game/map_data.dart';
import 'package:randuraft_web_app/global_setting/global_tree.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:randuraft_web_app/profile/user_data.dart';
//import 'dart:math' as math;

class BuildGame extends StatelessWidget {
  const BuildGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
/*
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
*/
/*
class _HomeScreenState extends State<HomeScreen> {
  final game = MyGame();
  TransformationController _controller = TransformationController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      double screenW = MediaQuery.of(context).size.width;
      double screenH = MediaQuery.of(context).size.height;
      double scaleW = screenW / game.mapWidth;
      double scaleH = screenH / game.mapHeight;
      double scale = math.min(scaleW, scaleH);
      _controller.value = Matrix4.identity()..scale(scale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interactive Map Example'),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: InteractiveViewer(
                transformationController: _controller,
                maxScale: 2.0,
                minScale: 0.5,
                child: GameWidget(game: game),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/

/*動く
class _HomeScreenState extends State<HomeScreen> {
  final game = MyGame();

  // Initial transformation for InteractiveViewer
  TransformationController _controller = TransformationController();

  @override
  void initState() {
    super.initState();
    // Set the initial transformation of the InteractiveViewer
    // to show the rightmost part of the game.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      double screenW = MediaQuery.of(context).size.width;
      double screenH = MediaQuery.of(context).size.height;

      // Calculate the initial translation to show the rightmost part
      double translateX = screenW - game.mapWidth;

      _controller.value = Matrix4.identity()..translate(translateX, 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interactive Map Example'),
      ),
      body: InteractiveViewer(
        transformationController: _controller,
        maxScale: 2.0,
        minScale: 0.5,
        child: GameWidget(game: game),
      ),
    );
  }
}
*/
/*class _HomeScreenState extends State<HomeScreen> {
  final game = MyGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interactive Map Example'),
      ),
      body: GameWidget(game: game),
    );
  }
}
*/
class _HomeScreenState extends State<HomeScreen> {
  final game = MyGame();

  @override
  Widget build(BuildContext context) {
    GlobalTree myTree = GlobalTree.instance;
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      myTree.addDataToFirestore(currentUser);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Map Example'),
      ),
      body: GestureDetector(
        onPanUpdate: game.onPanUpdate,
        child: GameWidget(game: game),
      ),
    );
  }
}

class MyGame extends Game {
  final tileSize = 16.0;

  //マップデータ
  late List<List<int>> mapData;
  late List<List<int>> floorData;

  //スプライト
  late SpriteSheet spriteSheet;
  late SpriteSheet playerSpriteSheet;
  late SpriteSheet slimeSpriteSheet;
  late SpriteSheet warlockSpriteSheet;
  late SpriteSheet skeletonSpriteSheet;
  late SpriteSheet dragonSpriteSheet;

  //木関連
  GlobalTree myTree = GlobalTree.instance;
  late List<List<int>> dynamicMap = generateCustomMatrix(
      myTree.maxMapHeight + (myTree.horizontalSpacing * 5),
      myTree.maxMapWidth + myTree.nodeWidth,
      0);
  late final int _maxWidth =
      myTree.maxMapHeight + (myTree.horizontalSpacing * (myTree.maxRank + 3));
  late final int maxHeight = myTree.maxMapWidth +
      myTree.nodeWidth +
      myTree.additionalParentChildDistance +
      myTree.verticalSpacing;
  double startingScale = 1.0;
  double currentScale = 1.0;
  Offset currentPanOffset = Offset.zero;

  //フラグ
  MyGame() {
    generateFloorData();
    mapData = generateMapData();
  }

  int get mapWidth => _mapWidth;
  int get mapHeight => _mapHeight;
  get _mapWidth =>
      (myTree.maxMapHeight + (myTree.horizontalSpacing * 5)) * tileSize;
  get _mapHeight =>
      (myTree.maxMapWidth +
          myTree.nodeWidth +
          myTree.additionalParentChildDistance +
          myTree.verticalSpacing) *
      tileSize;

  List<List<int>> generateMapData() {
    debugPrint(
        "Max Height: ${myTree.maxMapHeight}, Max Width: ${myTree.maxMapWidth}");
    debugPrint(
        "Matrix dimensions: ${dynamicMap.length}x${dynamicMap[0].length}");

    myTree.nodeList.forEach((key, node) {
      debugPrint("Checking node with x: ${node.x}, y: ${node.y}");

      if (node.x <= _maxWidth && node.y <= maxHeight) {
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
          for (var child in node.children!) {
            if (minY == null || child.y < minY) {
              minY = child.y;
              minNode = child;
            }
            if (maxY == null || child.y > maxY) {
              maxY = child.y;
              maxNode = child;
            }
          }
        }

        // Compute the length in y direction spanned by the children
        if (minY != null && maxY != null) {
          int yLength = maxY - minY;
          debugPrint(
              "yLength spanned by children of node with key $key: $yLength");
          debugPrint(
              "Min node: ${minNode?.title}, Max node: ${maxNode?.title}");
        } else {
          debugPrint(
              "Node with key $key has no children, so yLength is undefined.");
        }
        debugPrint('${node.rank} maxRank ${myTree.maxRank}');
      }
    });

    List<int> vertical = [2, 1, 15, 14, 13];
    List<int> horizontal = [8, 15, 7];
    List<int> verticalLeft = [16, 17, 15, 18, 19];
    List<int> verticalRight = [22, 23, 15, 21, 20];

    //エッジ作成
    myTree.nodeList.forEach((key, node) {
      if (node.x <= _maxWidth && node.y <= maxHeight) {
        // Initialize variables to hold the min and max y values and corresponding nodes
        int? minY;
        Node? minNode;
        int? maxY;
        Node? maxNode;

        // Loop through each child and update min and max y values and nodes
        if (node.children != null) {
          for (var child in node.children!) {
            if (minY == null || child.y < minY) {
              minY = child.y;
              minNode = child;
            }
            if (maxY == null || child.y > maxY) {
              maxY = child.y;
              maxNode = child;
            }
          }
        }
        /*
        // Compute the length in y direction spanned by the children
        if (minY != null && maxY != null) {
          int yLength = maxY! - minY!;
          debugPrint("yLength spanned by children of node with key $key: $yLength");
          debugPrint("Min node: ${minNode?.title}, Max node: ${maxNode?.title}");
        } else {
          debugPrint("Node with key $key has no children, so yLength is undefined.");
        }
        debugPrint('${node.rank} maxRank ${myTree.maxRank}');
        */

        if (node.rank != myTree.maxRank + 1 && node.countChildren() != 0) {
          //左道
          //done
          for (var child in node.children!) {
            int xLeftEdge = child.y + 2;
            int yLeftEdge = child.x +
                myTree.nodeWidth +
                (myTree.horizontalSpacing ~/ 2) -
                1;
            int endRight = child.x + myTree.nodeWidth - 1;

            for (int j = 0; j < 5; j++) {
              dynamicMap[xLeftEdge + j][yLeftEdge] = 4 + j * 2;
              dynamicMap[xLeftEdge + j][endRight] = verticalLeft[j];
            }
            for (int i = 1; i < (myTree.horizontalSpacing ~/ 2); i++) {
              for (int j = 0; j < 5; j++) {
                dynamicMap[xLeftEdge + j][yLeftEdge - i] = vertical[j];
              }
            }
          }
          //縦道
          //done

          int xMiddleEdge = minNode!.y + 4;
          int yMiddleEdge = node.x - (myTree.horizontalSpacing ~/ 2);

          dynamicMap[xMiddleEdge]
              .setRange(yMiddleEdge - 3, yMiddleEdge, [-1, 15, 8]);
          dynamicMap[xMiddleEdge + 1]
              .setRange(yMiddleEdge - 3, yMiddleEdge, [21, 15, 8]);
          dynamicMap[xMiddleEdge + 2]
              .setRange(yMiddleEdge - 3, yMiddleEdge, [20, 15, 8]);

          for (int i = xMiddleEdge + 3; i < maxNode!.y + 4; i++) {
            if (dynamicMap[i][yMiddleEdge - 3] == 2) {
              dynamicMap[i].setRange(yMiddleEdge - 3, yMiddleEdge, [22, 15, 8]);
              dynamicMap[i + 1]
                  .setRange(yMiddleEdge - 3, yMiddleEdge, [23, 15, 8]);
              if (i + 2 < maxNode.y + 4) {
                dynamicMap[i + 2]
                    .setRange(yMiddleEdge - 3, yMiddleEdge, [24, 15, 8]);
                dynamicMap[i + 3]
                    .setRange(yMiddleEdge - 3, yMiddleEdge, [21, 15, 8]);
                dynamicMap[i + 4]
                    .setRange(yMiddleEdge - 3, yMiddleEdge, [20, 15, 8]);
                i = i + 4;
              } else {
                i = i + 2;
              }
            } else {
              for (int j = 0; j < 3; j++) {
                dynamicMap[i][yMiddleEdge - j - 1] = horizontal[j];
              }
            }
          }
          //~done

          //右道
          for (int j = 0; j < 5; j++) {
            dynamicMap[node.y + 2 + j][node.x] = verticalRight[j];
            dynamicMap[node.y + 2 + j][yMiddleEdge - 1] = verticalLeft[j];
          }
          for (int i = 1; i < (myTree.horizontalSpacing ~/ 2) + 1; i++) {
            for (int j = 0; j < 5; j++) {
              dynamicMap[node.y + 2 + j][node.x - i] = vertical[j];
            }
          }
        }
      }
    });
    return dynamicMap;
  }

  List<List<int>> generateCustomMatrix(int rows, int cols, int num) {
    return List.generate(rows, (i) => List.generate(cols, (j) => num));
  }

  void generateFloorData() {
    int nodeHeight = myTree.nodeHeight;
    int nodeWidth = myTree.nodeWidth;
    floorData = generateCustomMatrix(nodeHeight, nodeWidth, 15);
    floorData[0] = [3] + List.filled(nodeWidth - 2, 2) + [4];
    floorData[1] = [5] + List.filled(nodeWidth - 2, 1) + [6];

    for (int i = 2; i < nodeHeight - 2; i++) {
      floorData[i] = [7] + List.filled(nodeWidth - 2, 15) + [8];
    }
    floorData[nodeHeight - 2] = [9] + List.filled(nodeWidth - 2, 14) + [10];
    floorData[nodeHeight - 1] = [11] + List.filled(nodeWidth - 2, 13) + [12];
  }

/*
  final List<Vector2> playerSprites = [
    Vector2(1, 0),
    Vector2(3, 7),
    Vector2(5, 7),
    Vector2(7, 7),
  ]; // プレイヤーの4つのスプライト座標
*/
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

    final slimeImage = await Flame.images.load('slime_.png');
    slimeSpriteSheet = SpriteSheet(
      image: slimeImage,
      srcSize: Vector2(8, 8),
    );

    final warlockImage = await Flame.images.load('warlock_.png');
    warlockSpriteSheet = SpriteSheet(
      image: warlockImage,
      srcSize: Vector2(8, 8),
    );

    final dragonImage = await Flame.images.load('dragon_.png');
    dragonSpriteSheet = SpriteSheet(
      image: dragonImage,
      srcSize: Vector2(8, 8),
    );

    final skeletonImage = await Flame.images.load('skeleton_.png');
    skeletonSpriteSheet = SpriteSheet(
      image: skeletonImage,
      srcSize: Vector2(8, 8),
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.save();

    // Scaling first
    canvas.scale(currentScale);
    canvas.translate(currentPanOffset.dx, currentPanOffset.dy);

    canvas.save();
    canvas.translate(-400, 50);
    canvas.scale(0.8);
    // 床レイヤーを描画
    for (int y = 0; y < mapData.length; y++) {
      for (int x = 0; x < mapData[y].length; x++) {
        final floorTile = mapData[y][x];
        drawTile(canvas, x, y + 1, floorTile, spriteCoordinatesFloor);
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
    drawEnemy(canvas, spritePlayer);
    //drawPlayer(canvas, spritePlayer);
    canvas.restore();
    canvas.restore();
  }

  void drawTile(Canvas canvas, int x, int y, int tileType,
      Map<int, Vector2> coordinates) {
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
      style: const TextStyle(color: Color(0xFFCEF09D), fontSize: 24.0),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Calculate the adjusted x-coordinate to center the text
    double centeredX =
        (x + (myTree.nodeWidth * 0.7) - (text.length / 2) - 2) * tileSize;

    final offset = Offset(centeredX, (y + 2) * tileSize);
    textPainter.paint(canvas, offset);
  }

  void drawNodeText(Canvas canvas) {
    myTree.nodeList.forEach((key, node) {
      drawText(canvas, node.title, node.x, node.y);
    });
  }

// Function to draw enemy on the canvas
  void drawEnemy(Canvas canvas, Map<int, Vector2> coordinates) {
    // Loop through each node in the tree
    myTree.nodeList.forEach((key, node) {
      // Define the tile types for each part of the enemy
      List<List<int>> tileTypes = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ];

      // Validate tileTypes
      if (tileTypes.isEmpty) {
        debugPrint("Error: tileTypes is not well-formed.");
        return;
      }

      // Loop through the rows and columns of tile types
      for (int row = 0; row < tileTypes.length; row++) {
        for (int col = 0; col < tileTypes[row].length; col++) {
          // Get the tile type and corresponding coordinate
          final tileType = tileTypes[row][col];
          final coord = coordinates[tileType] ?? Vector2.zero();
          final int doordone = (node.status != "done") ? 0 : 12;
          // Retrieve the sprite from the sprite sheet
          //final sprite = playerSpriteSheet.getSprite(coord.x.toInt(), coord.y.toInt());
          //final sprite = playerSpriteSheet.getSprite(0, 1);
          //debugPrint("${node.title} ${coord.x.toInt()},${coord.y.toInt()}");
          Sprite? sprite;

          if (node.parent == null) {
            sprite = dragonSpriteSheet.getSprite(
                coord.x.toInt() + doordone + 6, coord.y.toInt() + 21);
          } else {
            int hash = node.title.hashCode % 3;
            switch (hash) {
              case 0:
                sprite = warlockSpriteSheet.getSprite(
                    coord.x.toInt() + doordone, coord.y.toInt() + 21);
                break;
              case 1:
                sprite = skeletonSpriteSheet.getSprite(
                    coord.x.toInt() + doordone + 6, coord.y.toInt() + 21);
                break;
              case 2:
                sprite = slimeSpriteSheet.getSprite(
                    coord.x.toInt() + doordone, coord.y.toInt() + 21);
                break;
              default:
                break;
            }
          }
          // Handle if sprite is null
          if (sprite == null) {
            debugPrint("Error: Sprite not found.");
            continue;
          }

          // Calculate the position for rendering the sprite based on node position and tile size
          final dx = (node.x + row + (myTree.nodeWidth * 0.7) - 2) * tileSize;
          final dy = (node.y + col + 4) * tileSize;

          // Render the sprite on the canvas
          sprite.render(
            canvas,
            position: Vector2(dx, dy),
            size: Vector2(tileSize, tileSize),
          );
        }
      }
    });
  }

  void drawPlayer(Canvas canvas, Map<int, Vector2> coordinates) {
    // Loop through each node in the tree
    myTree.nodeList.forEach((key, node) {
      // Define the tile types for each part of the enemy
      List<List<int>> tileTypes = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ];
//      if(node.status=="doing"){
      if (node.status == "do") {
        for (int row = 0; row < tileTypes.length; row++) {
          for (int col = 0; col < tileTypes[row].length; col++) {
            // Get the tile type and corresponding coordinate
            final tileType = tileTypes[row][col];
            final coord = coordinates[tileType] ?? Vector2.zero();
            Sprite? sprite;

            sprite =
                playerSpriteSheet.getSprite(coord.x.toInt(), coord.y.toInt());

            // Calculate the position for rendering the sprite based on node position and tile size
            final dx = (node.x + row + 3) * tileSize;
            final dy = (node.y + col + 4) * tileSize;

            // Render the sprite on the canvas
            sprite.render(
              canvas,
              position: Vector2(dx, dy),
              size: Vector2(tileSize, tileSize),
            );
          }
        }

        const textSpan = TextSpan(
          text: "you",
          style: TextStyle(color: Color(0xFFCEF09D), fontSize: 24.0),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final offset = Offset((node.x + 3) * tileSize, (node.y + 2) * tileSize);
        textPainter.paint(canvas, offset);
      }
      // Validate tileTypes
      if (tileTypes.isEmpty) {
        debugPrint("Error: tileTypes is not well-formed.");
        return;
      }
    });
  }

  @override
  void onPanUpdate(details) {
    currentPanOffset += details.delta;
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    currentScale = (startingScale * details.scale).clamp(0.5, 2.0);
    currentPanOffset +=
        details.focalPoint - details.localFocalPoint; // Update pan offset
    debugPrint("Current Scale: $currentScale");
  }

  void onScaleStart(ScaleStartDetails details) {
    debugPrint("Scale Started");
    startingScale = currentScale;
  }

  void onScaleEnd(ScaleEndDetails details) {
    debugPrint("Scale Ended");
  }

  @override
  void update(double dt) {
    // 経過時間にdt（デルタタイム）を加算
  }
}

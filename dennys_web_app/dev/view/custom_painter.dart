import 'package:flutter/material.dart';
import 'package:dennys_web_app/global_setting/global_tree.dart';

class TreePainter extends CustomPainter {
  final Map<String, Node> nodeList;
  final double offsetX;  // 追加: X方向のオフセット
  final double offsetY;  // 追加: Y方向のオフセット

  TreePainter(this.nodeList, {this.offsetX = 100, this.offsetY = 100});  // オフセットを引数で受け取る

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    nodeList.forEach((key, node) {
      // ノードを描画
      //ここフレキシブルに
      final int nodeWidth = 125;
      final int nodeHeight = 50;

      final rect = Rect.fromPoints(
        Offset(node.x.toDouble() + offsetX, node.y.toDouble() + offsetY),  // オフセットを加算
        Offset(node.x.toDouble() + nodeWidth + offsetX, node.y.toDouble() + nodeHeight + offsetY),  // オフセットを加算
      );

      canvas.drawRect(rect, paint);

      // ノードのタイトルを描画
      textPainter.text = TextSpan(
        text: node.title,
        style: TextStyle(color: Colors.black),
      );
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(node.x.toDouble() + 5 + offsetX, node.y.toDouble() + 5 + offsetY));  // オフセットを加算

      // エッジを描画
      for (String childID in node.children) {
        Node? child = nodeList[childID];
        if (child != null) {
          canvas.drawLine(
            Offset(node.x.toDouble() + offsetX, node.y.toDouble() + nodeHeight / 2 + offsetY),  // x座標を親ノードの左端に, y座標を中央に
            Offset(child.x.toDouble() + nodeWidth + offsetX, child.y.toDouble() + nodeHeight / 2 + offsetY),  // x座標を子ノードの右端に, y座標を中央に
            Paint()
              ..color = Colors.red
              ..strokeWidth = 2,
          );
        }
      }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}


class TreePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 木構造のレイアウトを計算
    GlobalTree.instance.calculateLayout();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tree Structure'),
      ),
      body: CustomPaint(
        painter: TreePainter(GlobalTree.instance.nodeList, offsetX: 500, offsetY: 200),
      )
    );
  }
}


import 'package:flutter/material.dart';
import 'package:randuraft_web_app/global_setting/global_tree.dart';

class TreeNodeWidget extends StatelessWidget {
  final Node node;
  const TreeNodeWidget(this.node, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: node.x.toDouble(),
      top: node.y.toDouble(),
      child: GestureDetector(
        onTap: () => print('${node.title} tapped'),
        child: Container(
          width: 100,
          height: 50,
          color: Colors.blue,
          child: Center(
            child: Text(
              node.title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class TreeEdgeWidget extends StatelessWidget {
  final Node parent;
  final Node child;
  const TreeEdgeWidget(this.parent, this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    double startX = parent.x.toDouble(); // parent node's left edge
    double startY = parent.y.toDouble() + 25; // parent node's vertical center

    double endX = child.x.toDouble() + 100; // child node's right edge
    double endY = child.y.toDouble() + 25; // child node's vertical center

    double width = endX - startX;
    double height = endY - startY;

    return Positioned(
      left: startX,
      top: startY,
      child: GestureDetector(
        onTap: () {
          print("Edge tapped");
        },
        child: CustomPaint(
          size: Size(width, height),
          painter: LinePainter(const Offset(0, 0), Offset(width, height)),
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final Offset start;
  final Offset end;

  LinePainter(this.start, this.end);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class TreePage extends StatelessWidget {
  const TreePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 木構造のレイアウトを計算
    GlobalTree.instance.calculateLayout();

    List<Widget> widgets = [];

    GlobalTree.instance.nodeList.forEach((key, node) {
      widgets.add(TreeNodeWidget(node));

      for (String childID in node.children) {
        Node? child = GlobalTree.instance.nodeList[childID];
        if (child != null) {
          widgets.add(TreeEdgeWidget(node, child));
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tree Structure'),
      ),
      body: Stack(
        children: widgets,
      ),
    );
  }
}

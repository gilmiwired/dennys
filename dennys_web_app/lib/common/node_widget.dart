import 'package:flutter/material.dart';
import 'package:dennys_web_app/global_setting/global_tree.dart';

/*
class NodeWidget extends StatelessWidget {
  final Node node;

  NodeWidget({required this.node});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(node.title),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(node.title),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Status: ${node.status}'),
                  Text('Description: ${node.description}'),
                  Text('Children: ${node.children.join(', ')}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}*/
class NodeWidget extends StatelessWidget {
  final Node node;
  final GlobalTree globalTree;

  NodeWidget({required this.node, required this.globalTree});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(node.title),
      children: [
        for (var childKey in node.children)
          if (globalTree.nodeList.containsKey(childKey))
            NodeWidget(
              node: globalTree.nodeList[childKey]!,
              globalTree: globalTree,
            ),
      ],
    );
  }
}

class TreeView extends StatelessWidget {
  final GlobalTree globalTree;

  TreeView({required this.globalTree});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var rootKey in globalTree.tree.keys)
          if (!globalTree.collectedChildNodes.contains(rootKey))
            NodeWidget(
              node: globalTree.nodeList[rootKey]!,
              globalTree: globalTree,
            ),
      ],
    );
  }
}

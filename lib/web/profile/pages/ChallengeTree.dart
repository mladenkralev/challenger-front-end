import 'package:flutter/material.dart';
import 'package:graphite/graphite.dart';

import '../../../shared/services/UserManager.dart';

class DigimonData {
  final String imageUrl;
  final String title;
  final int level;

  DigimonData(
      {required this.imageUrl, required this.title, required this.level});
}

Map<String, DigimonData> data = {
  "botomon": DigimonData(
      title: "Botomon", level: 0, imageUrl: "assets/background.jpg"),
  "koromon": DigimonData(
      title: "Koromon", level: 1, imageUrl: "assets/background.jpg"),
  "agumon":
      DigimonData(title: "Agumon", level: 2, imageUrl: "assets/background.jpg"),
  "agumon_savers": DigimonData(
      title: "Agumon (Savers)", level: 2, imageUrl: "assets/background.jpg")
};

List<NodeInput> imagePreset = [
  NodeInput(
      id: "botomon",
      size: const NodeSize(width: 75, height: 75),
      next: [EdgeInput(outcome: "koromon", type: EdgeArrowType.one)]),
  NodeInput(
      id: "koromon",
      size: const NodeSize(width: 75, height: 75),
      next: [
        EdgeInput(outcome: "agumon", type: EdgeArrowType.one),
        EdgeInput(outcome: "agumon_savers", type: EdgeArrowType.one)
      ]),
  NodeInput(
      id: "agumon", size: const NodeSize(width: 75, height: 75), next: []),
  NodeInput(
      id: "agumon_savers",
      size: const NodeSize(width: 75, height: 75),
      next: []),
];

class ChallengeTree extends StatelessWidget {
  final UserManagerService userManager;

  BuildContext context;

  ChallengeTree(this.userManager, this.context);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Graphite',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: DigimonPage(),
    );
  }
}

class CurrentNodeInfo {
  final NodeInput node;
  final Rect rect;
  final DigimonData data;

  CurrentNodeInfo({required this.node, required this.rect, required this.data});
}

class DigimonPage extends StatefulWidget {
  // final Widget Function(BuildContext context) bottomBar;

  const DigimonPage({Key? key}) : super(key: key);

  @override
  DigimonPageState createState() => DigimonPageState();
}

class DigimonPageState extends State<DigimonPage>
    with SingleTickerProviderStateMixin {
  CurrentNodeInfo? _currentNodeInfo;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Widget> _buildOverlay(
      BuildContext context, List<NodeInput> nodes, List<Edge> edges) {
    return _currentNodeInfo == null ? [] : [_tooltip(context)];
  }

  Widget _tooltip(BuildContext context) {
    const tooltipHeight = 75.0;
    const maxWidth = 310.0;
    _animationController.reset();
    _animationController.forward();
    return Positioned(
        top: _currentNodeInfo!.rect.top - tooltipHeight,
        left: _currentNodeInfo!.rect.left + _currentNodeInfo!.rect.width * .9 - maxWidth * .4,
        child: SizedBox(
          width: maxWidth,
          height: tooltipHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _animation,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(225),
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 5),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text(
                          _currentNodeInfo!.data.title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          "Level: ${_currentNodeInfo!.data.level}",
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  _onNodeTap(TapUpDetails details, NodeInput node, Rect nodeRect) {
    setState(() {
      _currentNodeInfo =
          CurrentNodeInfo(node: node, rect: nodeRect, data: data[node.id]!);
    });
  }

  _onCanvasTap(TapDownDetails details) {
    setState(() {
      _currentNodeInfo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: InteractiveViewer(
            constrained: false,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 100.0),
                child: DirectGraph(
                    list: imagePreset,
                    defaultCellSize: const Size(100.0, 100.0),
                    cellPadding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    contactEdgesDistance: 5.0,
                    orientation: MatrixOrientation.Vertical,
                    clipBehavior: Clip.none,
                    centered: true,
                    minScale: .1,
                    maxScale: 3,
                    overlayBuilder: (BuildContext context,
                            List<NodeInput> nodes, List<Edge> edges) =>
                        _buildOverlay(context, nodes, edges),
                    onCanvasTap: _onCanvasTap,
                    onNodeTapUp: _onNodeTap,
                    nodeBuilder: (BuildContext context, NodeInput node) =>
                        ClipOval(
                          child: Image.asset(
                            data[node.id]!.imageUrl,
                            width: 100, // you can adjust the width
                            height: 100, // and height
                            fit: BoxFit.cover, //
                          ),
                        )))));
  }
}

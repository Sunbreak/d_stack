import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../d_stack.dart';

final GlobalKey<OverlayState> overlayKey = GlobalKey<OverlayState>();

class DStackApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DStackAppState();
}

class DStackAppState extends State<DStackApp> {
  final Map<String, PageHolder> _pageHolders = {};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Overlay(
        key: overlayKey,
      ),
    );
  }

  void handleActivate(DNode node) {
    var holder = _pageHolders[node.identifier];
    if (holder != null) {
      holder.widget.remove(); // remove widget in stack
    } else {
      holder = PageHolder.of(node);
      _pageHolders[node.identifier] = holder;
    }
    // insert widget onto top
    overlayKey.currentState?.insert(holder.widget);
  }
}

class PageHolder {
  final DNode node;
  final OverlayEntry widget;

  PageHolder.of(this.node)
      : widget =
            OverlayEntry(builder: DStack.getRouteBuilder(node.routeName)(node));
}

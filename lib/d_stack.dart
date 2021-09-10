import 'package:flutter/widgets.dart';

import 'src/d_channel.dart';
import 'src/d_entity.dart';

export 'src/d_entity.dart';
export 'src/d_stack_app.dart';

typedef TRouteBuilder = WidgetBuilder Function(DNode node);

class DStack {
  static final Map<String, TRouteBuilder> _routeBuilders = {};

  static void init(Map<String, TRouteBuilder> routeBuilders) {
    WidgetsFlutterBinding.ensureInitialized();
    DChannel.instance.init();
    _routeBuilders.addAll(routeBuilders);
  }

  static TRouteBuilder getRouteBuilder(routeName) => _routeBuilders[routeName]!;

  static void pushRoute(String routeName) {
    DChannel.instance.invokeActionToNative({
      'action': kActionPush,
      'routeName': routeName,
    });
  }

  static Future<void> pop() async {
    DChannel.instance.invokeActionToNative({
      'action': kActionPop,
    });
  }
}

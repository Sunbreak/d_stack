import 'package:flutter/services.dart';

import 'd_entity.dart';
import 'd_stack_app.dart';

const String kMethodActionToFlutter = 'methodActionToFlutter';
const String kMethodActionToNative = 'methodActionToNative';

const String kActionPush = "push";
const String kActionActivate = "activate";
const String kActionRemove = "remove";

final MethodChannel _channel = const MethodChannel('d_stack');

class DChannel {
  static final _instance = DChannel._();

  static DChannel get instance => _instance;

  DChannel._();

  DStackAppState? _stackAppState;

  void init() {
    _channel.setMethodCallHandler((MethodCall call) async {
      _ensureStackAppState();
      if (call.method == kMethodActionToFlutter) {
        handMethodActionToFlutter(call.arguments);
      }
    });
  }

  void _ensureStackAppState() {
    _stackAppState ??=
        overlayKey.currentContext?.findAncestorStateOfType<DStackAppState>();
  }

  Future<dynamic> handMethodActionToFlutter(Map arguments) async {
    switch (arguments['action']) {
      case kActionActivate:
        final map = arguments['node'].cast<String, dynamic>();
        _stackAppState!.handleActivate(DNode.fromMap(map));
        break;
      case kActionRemove:
        // TODO
        break;
    }
  }

  Future<void> invokeActionToNative(Map<String, Object> args) =>
      _channel.invokeMethod(kMethodActionToNative, args);
}

const kTNode = 'node';
const kTypeFlutter = 0;
const kTypeNative = 1;

class DNode {
  final String identifier;

  final String routeName;

  DNode(this.identifier, this.routeName);

  DNode.fromMap(Map<String, dynamic> map)
      : identifier = map['identifier'],
        routeName = map['routeName'];

  Map<String, dynamic> toMap() => {
        'identifier': identifier,
        'routeName': routeName,
      };
}

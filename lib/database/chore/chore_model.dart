part of database;

class ChoreModel {
  static const int _NAME_INDEX = 0;
  static const int _OWNER_INDEX = 1;
  static const int _DONE_INDEX = 2;
  static const int _INDEX_INDEX = 3;
  static const int _ID_INDEX = 4;

  String name, owner, id;
  bool done;
  int index;

  ChoreModel({this.name, this.owner, this.done, this.id, this.index = 0});

  static ChoreModel fromDefinition(ChoreDefinition definition) {
    int daysSince = definition.startDate.difference(DateTime.now()).inDays;
    String owner = definition.owners[daysSince % definition.owners.length];
    return ChoreModel(
      name: definition.name,
      owner: owner,
      done: false,
      id: definition.id,
      index: definition.index ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "owner": this.owner,
      "id": this.id,
      "done": this.done,
      "index": this.index,
    };
  }

  static ChoreModel fromJson(Map<String, dynamic> map) {
    return ChoreModel(
      name: map["name"] as String,
      owner: map["owner"] as String,
      done: map["done"] as bool ?? false,
      id: map["id"] as String,
      index: map["index"] as int,
    );
  }

  static ChoreModel fromString(String input) {
    Map map = Map.castFrom(json.decode(input)).cast<String, dynamic>();
    return fromJson(map);
  }

  @override
  String toString() {
    // DateTime now = DateTime.now();
    return jsonEncode(toJson());
  }
}

part of database;

class ChoreModel {
  static const int _NAME_INDEX = 0;
  static const int _OWNER_INDEX = 1;
  static const int _DONE_INDEX = 2;

  String name, owner;
  bool done;

  ChoreModel(this.name, this.owner, this.done);

  static ChoreModel fromDefinition(ChoreDefinition definition){
    String name = definition.name;
    int daysSince = definition.startDate.difference(DateTime.now()).inDays;
    String owner = definition.owners[daysSince % definition.owners.length];
    return ChoreModel(name, owner, false);
  }

  static ChoreModel fromString(String input){
    List<String> vals = input.split(",");
    if (vals.length < 3){
      print("Vals not long enough: '$input'");
      return null;
    }
    bool done = vals[_DONE_INDEX].toLowerCase() == "true";
    return ChoreModel(vals[_NAME_INDEX], vals[_OWNER_INDEX], done);
  }

  @override
  String toString() {
    // DateTime now = DateTime.now();
    // String dateString = "${now.year}/${now.month}/${now.day}";
    List<String> output = List(3);
    output[_NAME_INDEX] = this.name;
    output[_OWNER_INDEX] = this.owner;
    output[_DONE_INDEX] = "${this.done}";
    return output.join(",");
  }

}
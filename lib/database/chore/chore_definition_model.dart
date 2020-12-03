part of database;

class ChoreDefinition {
  static const int _NAME_INDEX = 0;
  static const int _OWNERS_INDEX = 1;
  static const int _START_INDEX = 2;
  static const String _SEPARATOR = "#|";

  String name;
  List<String> owners;
  DateTime startDate;

  ChoreDefinition(this.name, this.owners, this.startDate);

  String get currentOwner{
    return this.owners[this.startDate.difference(DateTime.now()).inDays%this.owners.length];
  }

  static ChoreDefinition fromString(String input){
    List<String> values = input.split(",");
    if (values.length < 3){
      return null;
    }
    DateTime start = DateTime.parse(values[_START_INDEX], );
    String ownersString = values[_OWNERS_INDEX];
    List<String> owners = ownersString.split(_SEPARATOR);

    return ChoreDefinition(values[_NAME_INDEX], owners, start);
  }

  @override
  String toString() {
    String dateString = "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
    // Remove any ; to not interfere with separations
    String ownersString = owners.map((n) => n.replaceAll(_SEPARATOR, "")).join(_SEPARATOR);

    List<String> outputStrings = new List(3);
    outputStrings[_NAME_INDEX] = this.name.replaceAll(_SEPARATOR, "");
    outputStrings[_OWNERS_INDEX] = ownersString;
    outputStrings[_START_INDEX] = dateString;

    return outputStrings.join(",");
  }

}
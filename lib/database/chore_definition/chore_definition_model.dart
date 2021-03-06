part of database;

class ChoreDefinition {
  static const int _NAME_INDEX = 0;
  static const int _OWNERS_INDEX = 1;
  static const int _START_INDEX = 2;
  static const int _ID_INDEX = 3;
  static const int _INDEX_INDEX = 4;
  static const String _SEPARATOR = "#|";
  static const int _ID_LENGTH = 30;

  static const String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static Random _rnd = Random();


  static String _getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  // String _originalName;
  // List<String> _originalOwners;
  // DateTime _originalStartDate;

  String _id;
  String name;
  List<String> owners;
  DateTime startDate;
  int index;

  String get id {
    return this._id;
  }

  ChoreDefinition({this.name, this.owners, this.startDate, String id, this.index=0}) {
    // this._originalName = name;
    // this._originalOwners = this.owners;
    // this._originalStartDate = this.startDate;
    this._id = (id == null || id.length == 0) ? _getRandomString(_ID_LENGTH) : id;
  }


  String get currentOwner {
    return this.owners[
        this.startDate.difference(DateTime.now()).inDays % this.owners.length];
  }

  // static ChoreDefinition fromString(String input) {
  //   List<String> values = input.split(",");
  //   if (values.length < 4) {
  //     return null;
  //   }
  //   DateTime start = DateTime.parse(
  //     values[_START_INDEX],
  //   );
  //   String ownersString = values[_OWNERS_INDEX];
  //   List<String> owners = ownersString.split(_SEPARATOR);
  //   String id = values[_ID_INDEX] ?? _getRandomString(30);
  //   print("Index ${values[_NAME_INDEX]} from string ${values[_INDEX_INDEX]}");
  //   int ind = int.parse(values[_INDEX_INDEX]);
  //
  //   return ChoreDefinition(values[_NAME_INDEX], owners, start, id: id, index:ind);
  // }

  // @override
  // String toString() {
  //   String dateString =
  //       "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
  //   // Remove any ; to not interfere with separations
  //   String ownersString =
  //       owners.map((n) => n.replaceAll(_SEPARATOR, "")).join(_SEPARATOR);
  //
  //   List<String> outputStrings = new List(5);
  //   outputStrings[_NAME_INDEX] = this.name.replaceAll(_SEPARATOR, "");
  //   outputStrings[_OWNERS_INDEX] = ownersString;
  //   outputStrings[_START_INDEX] = dateString;
  //   outputStrings[_ID_INDEX] = this._id;
  //   outputStrings[_INDEX_INDEX] = "${this.index}";
  //
  //   return outputStrings.join(",");
  // }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "owners": this.owners,
      "startDate": this.startDate.toIso8601String(),
      "index": this.index,
    };
  }

  static ChoreDefinition fromJson(Map<String, dynamic> map) {
    return ChoreDefinition(
      id: map["id"] as String,
      name: map["name"] as String,
      owners: (map["owners"] as List<dynamic>)?.cast<String>() ?? List(),
      startDate: DateTime.parse(map["startDate"]),
      index: map["index"] as int,
    );
  }

  static ChoreDefinition fromString(String input) {
    Map map = Map.castFrom(json.decode(input)).cast<String, dynamic>();
    return fromJson(map);
  }

  @override
  String toString() {
    // DateTime now = DateTime.now();
    return jsonEncode(toJson());
  }
}

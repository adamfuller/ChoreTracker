part of database;

class ChoreDefinition {
  static const int _NAME_INDEX = 0;
  static const int _OWNERS_INDEX = 1;
  static const int _START_INDEX = 2;
  static const int _ID_INDEX = 3;
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

  String get id {
    return this._id;
  }

  ChoreDefinition(this.name, this.owners, this.startDate, {String id}) {
    // this._originalName = name;
    // this._originalOwners = this.owners;
    // this._originalStartDate = this.startDate;
    this._id = (id == null || id.length == 0) ? _getRandomString(_ID_LENGTH) : id;
  }


  String get currentOwner {
    return this.owners[
        this.startDate.difference(DateTime.now()).inDays % this.owners.length];
  }

  static ChoreDefinition fromString(String input) {
    List<String> values = input.split(",");
    if (values.length < 3) {
      return null;
    }
    DateTime start = DateTime.parse(
      values[_START_INDEX],
    );
    String ownersString = values[_OWNERS_INDEX];
    List<String> owners = ownersString.split(_SEPARATOR);
    String id =
        values.length > _ID_INDEX ? values[_ID_INDEX] : _getRandomString(30);

    return ChoreDefinition(values[_NAME_INDEX], owners, start, id: id);
  }

  @override
  String toString() {
    String dateString =
        "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
    // Remove any ; to not interfere with separations
    String ownersString =
        owners.map((n) => n.replaceAll(_SEPARATOR, "")).join(_SEPARATOR);

    List<String> outputStrings = new List(4);
    outputStrings[_NAME_INDEX] = this.name.replaceAll(_SEPARATOR, "");
    outputStrings[_OWNERS_INDEX] = ownersString;
    outputStrings[_START_INDEX] = dateString;
    outputStrings[_ID_INDEX] = this._id;

    return outputStrings.join(",");
  }
}

part of database;

class ChoreDefinitionService {
  static const String _BASE_FOLDER = "/chores";

  // static const String _DEFINITIONS_ID = "definitions";
  // static const String _DEFINITION_SEPARATOR = "#%";

  static String _choreDefinitionsFolder() {
    return _BASE_FOLDER + "/definitions";
  }

  static Future<bool> storeChoreDefinition(ChoreDefinition definition) async {
    Completer<bool> output = Completer<bool>();

    String folder = _choreDefinitionsFolder();

    DatabaseService.setEntry(definition.id, folder, definition.toString()).then(
        (d) => output.complete(true),
        onError: (d) => output.complete(false));

    return output.future;
  }

  static Future<bool> storeChoreDefinitions(
      List<ChoreDefinition> definitions) async {
    Completer<bool> output = new Completer();
    List<Future<bool>> values =
        definitions.map((d) => storeChoreDefinition(d)).toList();
    for (int i = 0; i < definitions.length; i++) {
      definitions[i].index = i;
    }
    Future.wait(values).then((items) {
      output.complete(!items.any((e) => !e));
    });
    return output.future;
  }

  static Future<List<ChoreDefinition>> getAllChoreDefinitions() async {
    Completer<List<ChoreDefinition>> output =
        Completer<List<ChoreDefinition>>();
    String folder = _choreDefinitionsFolder();

    DatabaseService.getEntries(folder).then((values) {
      if (values.length == 0) {
        output.complete(List<ChoreDefinition>());
        return;
      }
      List<ChoreDefinition> choreDefinitions = List();
      for (String value in values) {
        ChoreDefinition definition = ChoreDefinition.fromString(value);
        if (definition != null) {
          choreDefinitions.add(definition);
        }
      }
      output.complete(choreDefinitions);
    });
    return output.future;
  }

  static Future<ChoreDefinition> getChoreDefinition(
      ChoreDefinition choreDefinition) async {
    Completer<ChoreDefinition> output = Completer();
    String folder = _choreDefinitionsFolder();
    DatabaseService.getEntry(choreDefinition.id, folder).then((value) {
      output.complete(ChoreDefinition.fromString(value));
    });
    return output.future;
  }

  static Future<bool> deleteChoreDefinition(
      ChoreDefinition choreDefinition) async {
    Completer<bool> output = Completer();

    String folder = _choreDefinitionsFolder();

    DatabaseService.deleteEntry(choreDefinition.id, folder);

    return output.future;
  }
}

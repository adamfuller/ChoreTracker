part of database;

class ChoreService{
  static String _folder = "/chores";
  static const String _DEFINITIONS_ID = "definitions";
  static const String _DEFINITION_SEPARATOR = "#%";

  static Future<List<ChoreModel>> getAllChores({List<ChoreDefinition> definitions}) async {
    definitions ??= await getAllChoreDefinitions();
    List<ChoreModel> output = List();

    for (ChoreDefinition definition in definitions){
      output.add(ChoreModel.fromDefinition(definition));
    }

    return output;
  }

  static String _todayFolder() {
    DateTime now = DateTime.now();
    return "${now.year}/${now.month}/${now.day}";
  }

  static Future<List<ChoreModel>> getCurrentChoresUsingChoreDefinitions() async {
    Completer<List<ChoreModel>> output = Completer();
    String folder = _todayFolder();

    getAllChoreDefinitions().then((choreDefinitions) async {
      List<ChoreModel> chores = List();
      for (ChoreDefinition definition in choreDefinitions){
        String data = await DatabaseService.getEntry(definition.name, folder);
        if (data.length <= 3){
          chores.add(ChoreModel.fromDefinition(definition));
          storeChore(chores.last); // store this one
          continue;
        }

        ChoreModel chore = ChoreModel.fromString(data);

        if (chore == null){
          continue;
        }

        chores.add(ChoreModel.fromString(data));
      }

      output.complete(chores);
    });

    return output.future;
  }

  static Future<List<ChoreModel>> getCurrentChores() async {
    Completer<List<ChoreModel>> output = Completer();
    String folder = _todayFolder();

    DatabaseService.getEntries(folder).then((values) {
      if (values == null || values.length == 0){
        print("Having to get from definitions");
        output.complete(getCurrentChoresUsingChoreDefinitions());
        return;
      }

      List<ChoreModel> chores = values.map((v) => ChoreModel.fromString(v)).toList();
      output.complete(chores);
    });

    return output.future;
  }

  static Future<bool> storeChore(ChoreModel chore) async{
    String folder = _todayFolder();
    print("Storing Chore: ${chore.name}, $folder, ${chore.toString()}");
    return DatabaseService.setEntry(chore.name, folder, chore.toString());
  }

  static Future<bool> storeChoreDefinition(ChoreDefinition definition) async {
    Completer<bool> output = Completer<bool>();

    getAllChoreDefinitions().then((allChoreDefinitions){
      if (allChoreDefinitions.where((n) => n.toString() == definition.toString()).isNotEmpty){
        return true;
      }

      // Remove current item
      allChoreDefinitions.removeWhere((e) => e.id == definition.id);

      // Add updated one
      allChoreDefinitions.add(definition);

      // Store them all again
      output.complete(storeChoreDefinitions(allChoreDefinitions));
    }, onError: (e){
      print(e);
      List<ChoreDefinition> newChores = List();
      newChores.add(definition);
      storeChoreDefinitions(newChores);
    });

    return output.future;
  }

  static Future<bool> storeChoreDefinitions(List<ChoreDefinition> definitions) async {
    String data = definitions.join(_DEFINITION_SEPARATOR);
    // print("Request Data: " + data);
    return DatabaseService.setEntry(_DEFINITIONS_ID, _folder, data);
  }

  static Future<List<ChoreDefinition>> getAllChoreDefinitions() async {
    Completer<List<ChoreDefinition>> output = Completer<List<ChoreDefinition>>();
    DatabaseService.getEntry(_DEFINITIONS_ID, _folder).then((value){
      // print("getAllChoreDefinitions: " + value);
      if (value.length <= 3){
        output.complete(List<ChoreDefinition>());
      } else {
        List<ChoreDefinition> chores = List<ChoreDefinition>();
        List<String> inputs = value.split(_DEFINITION_SEPARATOR);
        chores = inputs.map<ChoreDefinition>((n) => ChoreDefinition.fromString(n)).toList();
        output.complete(chores);
      }
    });
    return output.future;
  }

}
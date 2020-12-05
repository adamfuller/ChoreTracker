part of app;

class ManagerViewModel {
  //
  // Private members
  //
  List<StreamSubscription> _listeners;

  //
  // Public Properties
  //
  Function onDataChanged;
  bool isLoading = true;
  List<ChoreDefinition> chores = List();

  //
  // Getters
  //

  //
  // Constructor
  //
  ManagerViewModel(this.onDataChanged) {
    init();
  }

  //
  // Public functions
  //
  void init() async {
    this.isLoading = true;
    if (_listeners == null) _attachListeners();

    await _getChores();

    this.isLoading = false;
    print("Done with init");
    onDataChanged();
  }

  void addDefinitionPressed(BuildContext context) async {
    List<String> properties = await showMultipleInputDialog(
        context, "Create New Chore",
        hintTexts: ["Name", "Owners (Comma Separated)"], numInputs: 2);
    if (properties == null) {
      return;
    }
    DateTime now = DateTime.now();
    // Create Chore Definition for today at midnight
    ChoreDefinition cd = ChoreDefinition(properties[0],
        properties[1].split(","), DateTime(now.year, now.month, now.day, 0));
    ChoreDefinitionService.storeChoreDefinition(cd);
    ChoreModel chore = ChoreModel.fromDefinition(cd);
    if (chore != null){
      ChoreService.storeChore(chore);
    }
    chores.add(cd);
    onDataChanged();
  }

  void savePressed(BuildContext context, ChoreDefinition chore) async {
    bool doSave = await showConfirmDialog(context, "Save Chore?", "Do you want to save your changes to the chore?");
    if (doSave != true){
      return;
    }
    print("going to save: " + chore.toString());
    ChoreDefinitionService.storeChoreDefinition(chore);
  }

  void choresReordered(int oldIndex, int newIndex){
    newIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    ChoreDefinition oldOne = this.chores[oldIndex];
    ChoreDefinition newOne = this.chores[newIndex];
    this.chores[newIndex] = oldOne;
    this.chores[oldIndex] = newOne;
    // ChoreService.storeChoreDefinitions(this.chores);
    onDataChanged();
  }

  //
  // Private functions
  //
  void _attachListeners() {
    if (this._listeners == null) {
      this._listeners = [];
    }
  }

  Future<void> _getChores() async {
    this.chores = await ChoreDefinitionService.getAllChoreDefinitions();
  }

  void removeChore(BuildContext context, ChoreDefinition chore) async {
    bool remove = await showConfirmDialog(context, "Remove a chore?",
        "This will remove the chore from all devices, are you sure?");

    if (remove != true){
      return;
    }

    if (this.chores.length == 1){
      showAlertDialog(context, "Can't Remove All Chores", "You can't remove the final chore");
      return;
    }

    this.chores.remove(chore);

    // Override all available chores
    ChoreDefinitionService.deleteChoreDefinition(chore);
    onDataChanged();
  }

  //
  // Dispose
  //
  void dispose() {
    this._listeners?.forEach((_) => _.cancel());
  }


}

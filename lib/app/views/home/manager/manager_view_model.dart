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
  RefreshController refreshController;

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
    refreshController ??= RefreshController(initialRefresh: false);
    await _getChores();

    this.isLoading = false;
    onDataChanged();
    // Mark load and refresh completed
    refreshController.loadComplete();
    refreshController.refreshCompleted(resetFooterState: true);
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
        properties[1].split(","), DateTime(now.year, now.month, now.day, 0),
        index: chores.length);
    ChoreDefinitionService.storeChoreDefinition(cd);
    ChoreModel chore = ChoreModel.fromDefinition(cd);
    if (chore != null) {
      ChoreService.storeChore(chore);
    }
    chores.add(cd);
    onDataChanged();
  }

  void savePressed(BuildContext context, ChoreDefinition chore) async {
    bool doSave = await showConfirmDialog(context, "Save Chore?",
        "Do you want to save your changes to the chore?");
    if (doSave != true) {
      return;
    }
    print("going to save: " + chore.toString());
    ChoreDefinitionService.storeChoreDefinition(chore);
  }

  void choresReordered(int oldIndex, int newIndex) {
    newIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;

    ChoreDefinition orig = chores[oldIndex];
    chores.removeAt(oldIndex);
    chores.insert(newIndex, orig);

    int minIndex = min(newIndex, oldIndex);
    int maxIndex = max(newIndex, oldIndex);

    // Update all items in between
    for (int i = minIndex; i<=maxIndex; i++){
      ChoreDefinitionService.getChoreDefinition(chores[i]).then((def){
        def.index = i;
        ChoreDefinitionService.storeChoreDefinition(def);
      });
      chores[i].index = i;
    }

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
    chores = await ChoreDefinitionService.getAllChoreDefinitions();
    chores.sort((a,b) => a?.index?.compareTo(b?.index)??0);
    for (int i = 0; i<chores.length; i++){
      bool wasNull = chores[i].index == null;
      chores[i].index ??= i;
      if (wasNull){
        ChoreDefinitionService.storeChoreDefinition(chores[i]);
      }
    }
  }

  void removeChore(BuildContext context, ChoreDefinition chore) async {
    bool remove = await showConfirmDialog(context, "Remove a chore?",
        "This will remove the chore from all devices, are you sure?");

    if (remove != true) {
      return;
    }

    if (this.chores.length == 1) {
      showAlertDialog(context, "Can't Remove All Chores",
          "You can't remove the final chore");
      return;
    }

    int index = chores.indexOf(chore);
    this.chores.remove(chore);

    for (int i = index; i<chores.length; i++){
      ChoreDefinitionService.getChoreDefinition(chores[i]).then((def){
        def.index = i;
        ChoreDefinitionService.storeChoreDefinition(def);
      });
      chores[i].index = i;
    }

    // Override all available chores
    ChoreDefinitionService.deleteChoreDefinition(chore);
    ChoreService.deleteChore(ChoreModel.fromDefinition(chore));
    onDataChanged();
  }

  //
  // Dispose
  //
  void dispose() {
    this._listeners?.forEach((_) => _.cancel());
  }
}

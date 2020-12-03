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
  List<ChoreDefinition> chores;

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
    ChoreService.storeChoreDefinition(cd);
  }

  void savePressed(BuildContext context, ChoreDefinition chore) async {
    bool doSave = await showConfirmDialog(context, "Save Chore?", "Do you want to save your changes to the chore?");
    if (doSave != true){
      return;
    }
    ChoreService.storeChoreDefinition(chore);
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
    this.chores = await ChoreService.getAllChoreDefinitions();
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
    ChoreService.storeChoreDefinitions(this.chores);
    onDataChanged();
  }

  void addChore(ChoreDefinition chore) async {
    ChoreService.storeChoreDefinition(chore).then((n) {
      Future.delayed(Duration(milliseconds: 500)).then((n) {
        init();
      });
    });
  }

  //
  // Dispose
  //
  void dispose() {
    this._listeners?.forEach((_) => _.cancel());
  }


}

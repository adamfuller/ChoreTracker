part of app;

class HomeViewModel {
  //
  // Private members
  //
  List<StreamSubscription> _listeners;

  //
  // Public Properties
  //
  Function onDataChanged;
  bool isLoading = true;
  List<ChoreModel> chores;

  //
  // Getters
  //

  //
  // Constructor
  //
  HomeViewModel(this.onDataChanged) {
    init();
  }

  //
  // Public functions
  //
  void init() async {
    if (_listeners == null) _attachListeners();

    await _getChores();

    this.isLoading = false;
    print("Done with init");
    onDataChanged();
  }


  void menuPressed(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManagerView())).then((n){
      init();
    });
  }

  void markDone(ChoreModel chore, {bool isDone=true}){
    chore.done = isDone;
    ChoreService.storeChore(chore);
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
    chores = await ChoreService.getCurrentChores();
  }

  //
  // Dispose
  //
  void dispose() {
    this._listeners?.forEach((_) => _.cancel());
  }

}

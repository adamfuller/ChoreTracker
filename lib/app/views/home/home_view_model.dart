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

  RefreshController refreshController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

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

    refreshController ??= RefreshController(initialRefresh: false, initialRefreshStatus: RefreshStatus.completed);
    await _getChores();

    this.isLoading = false;
    print("Done with init");
    onDataChanged();
    refreshController.loadComplete();
    refreshController.refreshCompleted(resetFooterState: true);
  }

  void openSideMenuPressed(BuildContext context) {

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
    chores.sort((a,b) => a?.index?.compareTo(b?.index));
  }

  //
  // Dispose
  //
  void dispose() {
    this._listeners?.forEach((_) => _.cancel());
  }



}

part of app;

class ChoresViewModel {
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
  DateTime date;

  RefreshController refreshController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  //
  // Getters
  //

  //
  // Constructor
  //
  ChoresViewModel(this.onDataChanged, {this.date}) {
    init();
  }

  //
  // Public functions
  //
  void init() async {
    if (_listeners == null) _attachListeners();

    refreshController ??= RefreshController(
        initialRefresh: false, initialRefreshStatus: RefreshStatus.completed);
    await _getChores();

    this.isLoading = false;
    // print("Done with init");
    onDataChanged();
    refreshController.loadComplete();
    refreshController.refreshCompleted(resetFooterState: true);
  }

  void openSideMenuPressed(BuildContext context) {
    scaffoldKey.currentState.openEndDrawer();
  }

  void datePressed(BuildContext context) async {
    DateTime start = DateTime.now().subtract(Duration(days: 365 * 10));
    DateTime end = DateTime.now().add(Duration(seconds: 1));
    DateTime date = await showDatePicker(
      context: context,
      firstDate: start,
      lastDate: end,
      initialDate: DateTime.now(),
    );
    if (date == null) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChoresView(
          date: date,
          isHome: false,
        ),
      ),
    );
  }

  void menuPressed(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ManagerView()))
        .then((n) {
      init();
    });
  }

  void markDone(ChoreModel chore, {bool isDone = true}) {
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
    if (date == null){
      chores = await ChoreService.getCurrentChores();
    } else {
      chores = await ChoreService.getChores(date);
    }
    chores.sort((a, b) => a?.index?.compareTo(b?.index));
  }

  //
  // Dispose
  //
  void dispose() {
    this._listeners?.forEach((_) => _.cancel());
  }
}

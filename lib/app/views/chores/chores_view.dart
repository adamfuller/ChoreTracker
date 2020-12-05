part of app;

class ChoresView extends StatefulWidget {
  final bool isHome;
  final DateTime date;
  ChoresView({this.isHome=false, this.date});
  @override
  State<StatefulWidget> createState() {
    return _ChoresViewState();
  }
}

class _ChoresViewState extends State<ChoresView> {
  ChoresViewModel vm;

  @override
  void initState() {
    vm = ChoresViewModel(() {
      setState(() {});
    }, date: widget.date);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String dateString = "";
    if (widget.date != null){
      dateString = " - " + DateFormat("d MMM y").format(widget.date);
    }
    return Scaffold(
      key: vm.scaffoldKey,
      appBar: AppBar(
        title: Text("Chores" + dateString),
        backgroundColor: Colors.blueGrey,
        actions: widget.isHome ? [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => vm.datePressed(context),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => vm.menuPressed(context),
          ),
          // IconButton(
          //   icon: Icon(Icons.menu),
          //   onPressed: () => vm.openSideMenuPressed(context),
          // ),
        ] : [],
      ),
      endDrawer: widget.isHome ? _getEndDrawer(context) : null,
      body: vm.isLoading ? Loading() : _getBody(),
    );
  }

  Widget _getBody() {
    if (vm.chores == null || vm.chores.length == 0) {
      return Center(
        child: Text("No Chores Available"),
      );
    }
    return Center(
      child: SmartRefresher(
        enablePullDown: true,
        controller: vm.refreshController,
        header: WaterDropHeader(),
        onRefresh: vm.init,
        child: ListView.builder(
            itemCount: vm.chores?.length ?? 0,
            itemBuilder: (context, index) {
              return RoundedCard(
                child: ListTile(
                  title: Text(vm.chores[index].name),
                  subtitle: Text(vm.chores[index]?.owner?.trim()??""),
                  trailing: _getCompleteButton(vm.chores[index]),
                ),
              );
            }),
      ),
    );
  }

  Widget _getEndDrawer(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 3 / 4,
      height: MediaQuery.of(context).size.height,
      color: Colors.white60,
      child: Center(
        child: ListView(
          children: [
            Text("Hello", textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }

  Widget _getCompleteButton(ChoreModel chore) {
    return IconButton(
      icon: Icon(Icons.check_circle_outline_rounded),
      disabledColor: chore.done ? Colors.green : Colors.blueGrey,
      color: chore.done ? Colors.green : Colors.blueGrey,
      onPressed: widget.isHome ? () => vm.markDone(chore, isDone: !chore.done) : null,
    );
  }
}

part of app;

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
  HomeViewModel vm;

  @override
  void initState() {
    vm = HomeViewModel(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chores"),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => vm.menuPressed(context),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: vm.init,
          )
        ],
      ),
      body: vm.isLoading ? Loading() : _getBody(),
    );
  }

  Widget _getBody() {
    if (vm.chores == null || vm.chores.length == 0) {
      return Center(
        child: Text("No chores yet"),
      );
    }
    return Center(
      child: ListView.builder(
          itemCount: vm.chores?.length ?? 0,
          itemBuilder: (context, index) {
            return RoundedCard(
              child: ListTile(
                title: Text(vm.chores[index].name),
                subtitle: Text(vm.chores[index].owner),
                trailing: _getCompleteButton(vm.chores[index]),
              ),
            );
          }),
    );
  }

  Widget _getCompleteButton(ChoreModel chore) {
    return IconButton(
      icon: Icon(Icons.check_circle_outline_rounded),
      disabledColor: Colors.green,
      color: chore.done ? Colors.green : Colors.blueGrey,
      onPressed: () => vm.markDone(chore, isDone: !chore.done),
    );
  }
}

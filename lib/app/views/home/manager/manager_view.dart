part of app;

class ManagerView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ManagerViewState();
  }
}

class _ManagerViewState extends State<ManagerView> {
  ManagerViewModel vm;

  @override
  void initState() {
    vm = ManagerViewModel(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chore Manager"),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => vm.addDefinitionPressed(context),
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
      return Center(child: Text("No chores to manage  yet"));
    }

    return Center(
      child: ReorderableListView(
        onReorder: vm.choresReordered,
        // itemCount: vm.chores?.length ?? 0,
        children: vm.chores.map<Widget>((chore) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => vm.removeChore(context, chore),
              ),
            ],
            key: ValueKey(chore.id),
            child: _getChoreCard(chore),
          );
        }).toList(),
      ),
    );
  }

  Widget _getChoreCard(ChoreDefinition chore){
    return RoundedCard(
      child: Padding(
        padding: EdgeInsets.fromLTRB(3, 0, 3, 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              color: Colors.green,
              icon: Icon(Icons.save),
              onPressed: () => vm.savePressed(context, chore),
            ),
            _getDefinitionInputs(context, chore),
            Padding(
              padding: EdgeInsets.all(5),
              child: Icon(Icons.drag_handle),
            ),
          ],
        ),
      ),
    );
  }

  _getDefinitionInputs(BuildContext context, ChoreDefinition chore) {
    TextEditingController tecName = TextEditingController();
    tecName.text = chore.name;

    TextEditingController tecOwners = TextEditingController();
    tecOwners.text = chore.owners.join(",");

    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
            child: Text(
              "ID: ${chore.id}",
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          TextField(
            controller: tecName,
            decoration: InputDecoration(
              prefixText: "Name: ",
            ),
            onChanged: (s) => chore.name = s,
          ),
          TextField(
            controller: tecOwners,
            decoration: InputDecoration(
              prefixText: "Owners: ",
            ),
            onChanged: (s) => chore.owners = s.split(','),
          ),
        ],
      ),
    );
  }
}

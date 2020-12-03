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

  Widget _getBody(){

    if (vm.chores == null || vm.chores.length == 0){
      return Center(child: Text("No chores to manage  yet"));
    }

    return Center(
      child: ListView.builder(
          itemCount: vm.chores?.length ?? 0,
          itemBuilder: (context, index) {
            ChoreDefinition chore = vm.chores[index];
            TextEditingController tecName = TextEditingController();
            tecName.text = chore.name;

            TextEditingController tecOwners = TextEditingController();
            tecOwners.text = chore.owners.join(",");

            return RoundedCard(
              child: Padding(
                padding: EdgeInsets.all(3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      color: Colors.green,
                      icon: Icon(Icons.save),
                      onPressed: () => vm.savePressed(context, vm.chores[index]),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextField(
                            controller: tecName,
                            decoration: InputDecoration(
                              prefixText: "Name: ",
                            ),
                          ),
                          TextField(
                            controller: tecOwners,
                            decoration: InputDecoration(
                              prefixText: "Owners: ",
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      color: Colors.red,
                      icon: Icon(Icons.delete_forever),
                      onPressed: () =>
                          vm.removeChore(context, vm.chores[index]),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _getCompleteButton(ChoreModel chore) {
    return IconButton(
      icon: Icon(Icons.check_circle_outline_rounded),
      disabledColor: Colors.green,
      onPressed: chore.done
          ? null
          : () {
              chore.done = true;
              vm.onDataChanged();
            },
    );
  }
}

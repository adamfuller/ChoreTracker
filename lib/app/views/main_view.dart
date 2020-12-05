part of app;

class MainView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainViewState();
  }
}

class _MainViewState extends State<MainView> {
  MainViewModel vm;

  @override
  void initState() {
    vm = MainViewModel(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        //accentColor: Color(0xFFFF483e),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          color: Colors.transparent,
          //iconTheme: Theme.of(context).iconTheme,
        ),

      ),
      debugShowCheckedModeBanner: false,
      home: _getHome(),
    );
  }

  Widget _getHome() {
    if (vm.isLoading) {
      return Loading();
    } else {
      return ChoresView(isHome:true);
    }
  }
}
part of app;

Future<void> showAlertDialog(BuildContext context, String title, String subtitle) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(title),
        content: Text(subtitle),
        actions: <Widget>[
          FlatButton(
            child: const Text("Ok"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}

Future<bool> showConfirmDialog(
    BuildContext context,
    String title,
    String subtitle, {
      String confirmText = "Ok",
      String denyText = "Cancel",
    }) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(title),
        content: Text(subtitle),
        actions: <Widget>[
          FlatButton(
            child: Text(denyText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          FlatButton(
            child: Text(confirmText),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  );
}

Future<dynamic> showCustomDialog(BuildContext context, Widget child) async {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Color.fromARGB(100, 100, 100, 100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          height: 280,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(child: child),
        ),
      );
    },
  );
}

Future<dynamic> showCustomHeroDialog(BuildContext context, Widget child) async {
  return Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      pageBuilder: (BuildContext context, _, __) => child,
    ),
  );
}

Future<String> showInputDialog(
    BuildContext context,
    String title, {
      String subtitle,
      TextInputType keyboardType,
      String hintText,
      int maxLines,
      int codeLength = 10,
    }) async {
  TextEditingController _inputController = TextEditingController();
  return showDialog<String>(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              subtitle != null ? Text(subtitle ?? "") : null,
              TextField(
                autofocus: true,
                keyboardType: keyboardType ?? TextInputType.text,
                controller: _inputController,
                maxLines: maxLines,
                decoration: InputDecoration(
                  hintText: hintText,
                ),
              ),
            ]..removeWhere((_) => _ == null),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: const Text("Ok"),
            onPressed: () => Navigator.of(context).pop(_inputController.text),
          ),
        ]..removeWhere((_) => _ == null),
      );
    },
  );
}

Future<List<String>> showMultipleInputDialog(
    BuildContext context,
    String title, {
      int numInputs = 1,
      String subtitle,
      TextInputType keyboardType,
      List<String> hintTexts,
      int maxLines,
      int codeLength = 10,
      EdgeInsets inputPadding = const EdgeInsets.only(bottom: 8.0),
      List<bool> obscureText,
    }) async {
  List<TextEditingController> _inputControllers = List<TextEditingController>.generate(numInputs, (i) => TextEditingController());
  return showDialog<List<String>>(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              subtitle != null ? Text(subtitle ?? "") : null,
            ]
              ..addAll(List<Widget>.generate(numInputs, (index) {
                return Padding(
                  padding: inputPadding,
                  child: TextField(
                    autofocus: true,
                    obscureText: (obscureText?.length != null && obscureText.length > index) ? obscureText[index] : false,
                    keyboardType: keyboardType ?? TextInputType.text,
                    controller: _inputControllers[index],
                    maxLines: maxLines,
                    decoration: InputDecoration(
                      hintText: hintTexts[index],
                    ),
                  ),
                );
              }))
              ..removeWhere((_) => _ == null),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: const Text("Ok"),
            onPressed: () => Navigator.of(context).pop(
              List<String>.generate(numInputs, (i) => _inputControllers[i].text),
            ),
          ),
        ]..removeWhere((_) => _ == null),
      );
    },
  );
}
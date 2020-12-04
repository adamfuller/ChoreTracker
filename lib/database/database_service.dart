library database.database_service;

import 'dart:async';
import "dart:io";

class DatabaseService{
  static const String _SERVER = "www.octalbyte.com";
  static const int _PORT = 8081;

  static Future<List<String>> getEntries(String path) async{
    Completer<List<String>> output = Completer<List<String>>();
    Socket socket = await Socket.connect(_SERVER, _PORT, timeout: Duration(seconds: 5));
    socket.write("::${path.replaceAll(":", "_:_")}:::");// send request for item at path
    await socket.flush();

    socket.listen((value) {
      String input = new String.fromCharCodes(value); // convert bytes back
      // print("Value: " + input);
      List<String> values = input.split("::").map((n) => n.replaceAll("_:_", ":")).toList(); // Split and make safe
      values.removeWhere((element) => element == null || element == "" || element == " ");
      // print(values);
      output.complete(values); // Record output
      socket.close();
    }, onError: (e){
      print(e.toString());
      socket.close();
      output.complete(null);
    });

    return output.future;
  }


  static Future<String> getEntry(String id, String path) async{
    // Future<String> output = Future<String>();
    Completer<String> output = Completer<String>();
    Socket socket = await Socket.connect(_SERVER, _PORT, timeout: Duration(seconds: 5));
    socket.write("${id.replaceAll(":", "_:_")}::${path.replaceAll(":", "_:_")}:::");// send request for item at path
    await socket.flush();

    socket.listen((value) {
      output.complete(new String.fromCharCodes(value).replaceAll("_:_", ":")); // convert bytes back
      socket.close();
    }, onError: (e){
      print(e.toString());
      socket.close();
      output.complete(null);
    });

    return output.future;
  }


  static Future<bool> setEntry(String id, String path, String value) async{
    Completer<bool> output = Completer<bool>();
    Socket socket = await Socket.connect(_SERVER, _PORT, timeout: Duration(seconds: 5));
    // Ensure bytes are safe
    socket.write("${id.replaceAll(":", "_:_")}::${path.replaceAll(":", "_:_")}::${value.replaceAll(":", "_:_")}:::");// send request for item at path
    await socket.flush();

    socket.listen((value) {
      if (!output.isCompleted){
        output.complete(true);
      }
      socket.close();
    }, onError: (e){
      socket.close();
      output.complete(false);
    }, onDone: (){
      if (!output.isCompleted){
        output.complete(true);
      }
    });

    return output.future;
  }

}
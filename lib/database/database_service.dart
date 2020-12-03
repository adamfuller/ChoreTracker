library database.database_service;

import 'dart:async';
import "dart:io";

class DatabaseService{
  static const String _SERVER = "www.octalbyte.com";
  static const int _PORT = 8081;

  static Future<String> getEntry(String id, String path) async{
    // Future<String> output = Future<String>();
    Completer<String> output = Completer<String>();
    Socket socket = await Socket.connect(_SERVER, _PORT, timeout: Duration(seconds: 5));
    socket.write("$id::$path:::");// send request for item at path
    await socket.flush();

    socket.listen((value) {
      output.complete(new String.fromCharCodes(value));
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
    socket.write("$id::$path::$value:::");// send request for item at path
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
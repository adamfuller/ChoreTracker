library database.database_service;

import 'dart:async';
import "dart:io";

class DatabaseService {
  static const String _SERVER = "www.octalbyte.com";
  static const int _PORT = 8081;
  static const String _FETCH = "FETCH";
  static const String _STORE = "STORE";
  static const String _DELETE = "DELETE";

  static Future<List<String>> getEntries(String path) async {
    Completer<List<String>> output = Completer<List<String>>();
    Socket socket =
        await Socket.connect(_SERVER, _PORT, timeout: Duration(seconds: 5));
    // print("$_FETCH::${path.replaceAll(":", "_:_")}:::");
    socket.write(
        "$_FETCH::${path.replaceAll(":", "_:_")}:::"); // send request for item at path
    await socket.flush();

    String lastInput = "";
    List<String> allValues = List();
    socket.listen((value) {
      String input =
          lastInput + new String.fromCharCodes(value); // convert bytes back
      print("Value: " + input);
      List<String> values = input
          .split("::")
          .map((n) => n.replaceAll("_:_", ":"))
          .toList(); // Split and make safe
      lastInput =
          values[values.length - 1]; // last input is the final item is values
      values.removeAt(values.length - 1);
      allValues.addAll(values.where((n) => n.trim().length > 0));
      // print(values);
      // output.complete(values); // Record output
      socket.close();
    }, onError: (e) {
      print(e.toString());
      socket.close();
      output.complete(null);
    }, onDone: () {
      if (lastInput.trim().length > 0) {
        allValues.add(lastInput);
      }
      output.complete(allValues);
    });

    return output.future;
  }

  static Future<String> getEntry(String id, String path) async {
    // Future<String> output = Future<String>();
    Completer<String> output = Completer<String>();
    Socket socket =
        await Socket.connect(_SERVER, _PORT, timeout: Duration(seconds: 5));
    // print(
        // "$_FETCH::${path.replaceAll(":", "_:_")}::${id.replaceAll(":", "_:_")}:::");
    socket.write(
        "$_FETCH::${path.replaceAll(":", "_:_")}::${id.replaceAll(":", "_:_")}:::"); // send request for item at path
    await socket.flush();

    String input = "";
    socket.listen((value) {
      print("socket returned '$value'");
      input += String.fromCharCodes(value).replaceAll("_:_", ":");
      // output.complete(input); // convert bytes back
      socket.close();
    }, onError: (e) {
      print(e.toString());
      socket.close();
      output.complete(null);
    }, onDone: () {
      output.complete(input);
    });

    return output.future;
  }

  static Future<bool> setEntry(String id, String path, String value) async {
    Completer<bool> output = Completer<bool>();
    Socket socket =
        await Socket.connect(_SERVER, _PORT, timeout: Duration(seconds: 5));
    // print("$_STORE::${path.replaceAll(":", "_:_")}::${id.replaceAll(":", "_:_")}::${value.replaceAll(":", "_:_")}:::");
    // Ensure bytes are safe
    socket.write(
        "$_STORE::${path.replaceAll(":", "_:_")}::${id.replaceAll(":", "_:_")}::${value.replaceAll(":", "_:_")}:::"); // send request for item at path
    await socket.flush();

    socket.listen((value) {
      if (!output.isCompleted) {
        output.complete(true);
      }
      socket.close();
    }, onError: (e) {
      socket.close();
      output.complete(false);
    }, onDone: () {
      if (!output.isCompleted) {
        output.complete(true);
      }
    });

    return output.future;
  }

  static Future<bool> deleteEntry(String id, String path) async {
    Completer<bool> output = Completer<bool>();
    Socket socket =
        await Socket.connect(_SERVER, _PORT, timeout: Duration(seconds: 5));
    // Ensure bytes are safe
    socket.write(
        "$_DELETE::${path.replaceAll(":", "_:_")}::${id.replaceAll(":", "_:_")}:::"); // send request for item at path
    await socket.flush();

    socket.listen((value) {
      if (!output.isCompleted) {
        output.complete(true);
      }
      socket.close();
    }, onError: (e) {
      socket.close();
      output.complete(false);
    }, onDone: () {
      if (!output.isCompleted) {
        output.complete(true);
      }
    });

    return output.future;
  }
}

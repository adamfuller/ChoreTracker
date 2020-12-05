library database.database_service;

import 'dart:async';
import "dart:io";

import 'package:meta/meta.dart';

class DatabaseService {
  static const String _SERVER = "www.octalbyte.com";
  static const int _PORT = 8081;
  static const String _FETCH = "FETCH";
  static const String _STORE = "STORE";
  static const String _DELETE = "DELETE";
  static Duration _timeout = Duration(seconds: 5);

  static String _makeSafe(String input) {
    return input.replaceAll(":", "_:_");
  }

  static String _getOperation({
    @required String op,
    @required String path,
    String id,
    String value,
  }) {
    switch (op) {
      case _FETCH:
        if (id == null) {
          return "$op::${_makeSafe(path)}:::";
        }
        return "$op::${_makeSafe(path)}::${_makeSafe(id)}:::";
      case _STORE:
        return "$op::${_makeSafe(path)}::${_makeSafe(id)}::${_makeSafe(value)}:::";
      case _DELETE:
        return "$op::${_makeSafe(path)}::${_makeSafe(id)}:::";
    }
    return "$op::${_makeSafe(path)}::${_makeSafe(id)}:::";
  }

  static Future<List<String>> getEntries(String path) async {
    Completer<List<String>> output = Completer<List<String>>();

    Socket socket = await Socket.connect(_SERVER, _PORT, timeout: _timeout);
    String operation = _getOperation(op: _FETCH, path: path);
    print(operation);
    socket.write(operation); // send request for item at path
    await socket.flush();

    String lastInput = "";
    List<String> allValues = List();
    socket.listen((value) {
      // convert bytes back
      String input = lastInput + String.fromCharCodes(value);
      // print("Value: " + input);
      List<String> values = input
          .split("::")
          .map((n) => n.replaceAll("_:_", ":"))
          .toList(); // Split and make safe
      // last input is the final item is values
      lastInput = values[values.length - 1];
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
    Socket socket = await Socket.connect(_SERVER, _PORT, timeout: _timeout);
    String operation = _getOperation(op: _FETCH, path: path, id: id);
    // print(operation);
    socket.write(operation); // send request for item at path
    await socket.flush();

    String input = "";
    socket.listen((value) {
      // print("socket returned '$value'");
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
    Socket socket = await Socket.connect(_SERVER, _PORT, timeout: _timeout);
    // Ensure bytes are safe
    String operation = _getOperation(op:_STORE, path:path, id:id, value:value);
    // print(operation);
    socket.write(operation); // send request for item at path
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
    Socket socket = await Socket.connect(_SERVER, _PORT, timeout: _timeout);
    // Ensure bytes are safe
    String operation = _getOperation(op: _DELETE, path: path, id: id);
    // print(operation)
    socket.write(operation); // send request for item at path
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

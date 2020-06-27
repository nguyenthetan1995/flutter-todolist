import 'dart:async';
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/global.dart';

class Todo {
  String id;
  String name;
  bool isDone;

  Todo({
    this.id,
    this.name,
    this.isDone
  });
  
  factory Todo.fromJSON(Map<String, dynamic> json){
    return Todo(
        id: json["id"],
        name: json["name"],
        isDone: json["isDone"]
    );
  }
  
}
//Fetch data
Future<List<Todo>> fetchTodos(http.Client client) async {
    final response = await client.get(GET_URL_TODOS);
    if (response.statusCode == 200) {
      List mapResponse = json.decode(response.body);
      //if (mapResponse["result"] == true) {\
      var todos=new List<Todo>();
      if(mapResponse is List){
        //mapResponse.map((e) => todos.add(e));
        final todos1 = mapResponse.cast<Map<String, dynamic>>();
        final listOfTodos = await todos1.map<Todo>((json){
          return Todo.fromJSON(json);
        }).toList();
        return listOfTodos;
      }
    }
    else{
      throw Exception('Error!');
    }
  }
//Update todos
Future<dynamic> updateTodos(http.Client client,Map<String, dynamic> param) async {
  Map<String, dynamic> parambody = Map<String, dynamic> ();
  parambody["name"]= param["name"];
  parambody["isDone"] = param["isDone"];
  print(param);
  var url=UPDATE_TODOS+param["id"];

  var todo=new Todo(id: param["id"],name: param["name"],isDone: param["isDone"]);
  final response = await client.put(UPDATE_TODOS+param["id"],body:jsonEncode(parambody),headers: {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  });
  if (response.statusCode == 200) {
    final responsedata = await jsonEncode(response.body);
    print(jsonDecode(responsedata));
    return responsedata;

  }
  else{
    throw Exception('Error!');
  }
}
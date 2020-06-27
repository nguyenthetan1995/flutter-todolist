import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'taskScreen.dart';
import 'models/todo.dart';

class TodoScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return  TodoScreenState();
  }
}
class Todolist extends StatelessWidget{
  final List<Todo> todos;
  Todolist({Key key, this.todos}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index){
        return GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            color: index%2 ==0 ?  Colors.greenAccent : Colors.cyan,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(todos[index].name, style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),),
                new Text(todos[index].isDone.toString(), style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 11.0) )
              ],
            )
          ),
          onTap: (){
            Navigator.push(context,
              new MaterialPageRoute(builder: (context)=> new TaskScreen(todoId: todos[index].id,name:todos[index].name, isDone:todos[index].isDone))
            );
          },
        );
      }
    );
  }
}

class TodoScreenState extends State<TodoScreen>{
  @override
  Widget build(BuildContext context) {
    //TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Todos list'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {}
          )
        ],
      ),
      body: FutureBuilder(
        future: fetchTodos(http.Client()),
        builder: (context, snapshot){
          if(snapshot.hasError){
            print(snapshot.error);
          }
          if( snapshot.hasData )
          {
            print(( snapshot.data));
            return Todolist(todos: snapshot.data);
          }
          else{
            return Center(child: CircularProgressIndicator());
          }

        }
      ),
    );
  }
}

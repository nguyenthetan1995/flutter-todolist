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


class TodoScreenState extends State<TodoScreen>{
  Todo todo = new Todo();
  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Todo Name', hintText: 'eg. Learn Flutter'),
                controller: TextEditingController(text: this.todo.name),
                onChanged: (text){
                  this.todo.name = text;
                },
              ),
            ),

          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('OK'),
              onPressed: () async {
                Map<String, dynamic> param = Map<String, dynamic> ();
                param["isDone"]  = false;
                param["name"] = this.todo.name;
                await AddTodos(http.Client(),param);
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    //TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Todos list'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _showDialog();
              }
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
            return
            ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  return GestureDetector(
                    child: Container(
                        padding: const EdgeInsets.all(10.0),
                        color: index%2 ==0 ?  Colors.white : Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            index%2 ==0 ? new Text(snapshot.data[index].name, style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),) : new Text(snapshot.data[index].name, style: new TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16.0),),
                            index%2 ==0 ? new Text(snapshot.data[index].isDone.toString(), style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 11.0) ) : new Text(snapshot.data[index].isDone.toString(), style: new TextStyle(color: Colors.white,fontWeight: FontWeight.normal, fontSize: 11.0) )
                          ],
                        )
                    ),
                    onTap: ()async {
                      await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> new TaskScreen(todoId: snapshot.data[index].id,name:snapshot.data[index].name, isDone:snapshot.data[index].isDone))
                      );
                      setState(() {});
                    },
                  );
                }
            );
          }
          else{
            return Center(child: CircularProgressIndicator());
          }

        }
      ),
    );
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'models/todo.dart';

class TaskScreen extends StatefulWidget{
  String todoId;
  String name;
  bool isDone;
  Todo task;
  TaskScreen({Key key, this.todoId,this.name,this.isDone}) : super();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TaskScreenState();
  }
}

class TaskScreenState extends State<TaskScreen>{
  Todo task = new Todo();
  bool isLoadedTask = false;
  TextEditingController ctr= TextEditingController();
  TextField txttext;
  @override
  Widget build(BuildContext context) {

   if(isLoadedTask == false){
     setState(() {
       this.task=Todo(id: widget.todoId,isDone: widget.isDone,name: widget.name);
       this.isLoadedTask = true;
     });
   }
   txttext  = TextField(
     decoration: InputDecoration(
         hintText: "Enter your task's name",
         contentPadding: EdgeInsets.all(10.0),
         border: OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(36, 146, 237, 1)))
     ),
     autocorrect: false,
     controller: TextEditingController(text: this.task.name),
     textAlign: TextAlign.left,
     onChanged: (text){
       //ctr.text=text;
       this.task.name = text;
     },
   );
   final Checkbox checkboxfinished = new Checkbox(value: this.task?.isDone??false,
       onChanged: (bool value){
         setState(() {
           this.task.isDone = value;
         });
       }
   );
   final Text finished = new Text('Finished', style: TextStyle(fontSize: 16.0));
   final btnSave = new RaisedButton(
     child: Text('Save', style: TextStyle(color:Colors.white )),
     color: Theme.of(context).accentColor,
     padding: const EdgeInsets.only(right: 10.0),
     elevation: 4.0,
     onPressed: () async {
       Map<String, dynamic> param = Map<String, dynamic> ();
       param["id"] = this.task.id;
       param["isDone"] = this.task.isDone;
       param["name"] = this.task.name;

        await updateTodos(http.Client(),param);

        Navigator.pop(context,(){
          setState(() {});
        });
     },
   );
   final btnDelete = new RaisedButton(

     child: Text('Delete', style: TextStyle(color:Colors.white ),),
     color: Colors.red,
     elevation: 4.0,
     padding: const EdgeInsets.all(10.0),
     onPressed: ()  {
       Map<String, dynamic> param = Map<String, dynamic> ();
       param["id"] = this.task.id;
       param["isDone"] = this.task.isDone;
       param["name"] = this.task.name;
       showDialog(
         context: context,
         builder: (BuildContext context) {
           // return object of type Dialog
           return AlertDialog(
             title: new Text("Delete todo"),
             actions: <Widget>[
               // usually buttons at the bottom of the dialog
               new FlatButton(
                 child: new Text("Cancel"),
                 onPressed: ()  {
                   Navigator.of(context).pop();

                 },
               ),
               new FlatButton(
                 child: new Text("OK"),
                 onPressed: () async {
                   await deleteTodos(http.Client(),param);
                   await Navigator.of(context).pop();
                   Navigator.pop(context, (){
                     setState(() {});
                   });
                 },
               ),
             ],
           );
         },
       );

     },
   );
   final Colum = new Column(
     crossAxisAlignment: CrossAxisAlignment.center,
     mainAxisAlignment: MainAxisAlignment.start,
     children: <Widget>[
       txttext,
       Container(

         child: Row(
           mainAxisAlignment: MainAxisAlignment.start,
           children: <Widget>[
             checkboxfinished,
             finished
           ],
         ),
       ),
       Row(
         children: <Widget>[
           Expanded(
             child:  Padding(
               padding: const EdgeInsets.all(10.0),
               child: btnSave,
             )
           ),
           Expanded(
             child: Padding(
               padding: const EdgeInsets.all(10.0),
               child: btnDelete,
             )
           ),


         ],
       )
     ],
   );
  return new Scaffold(
       appBar: new AppBar(
         title: Text('Task detail'),
       ),
       body: Container(
         padding: EdgeInsets.all(10.0),
         child: Colum,
       )
   );

  }
}

import 'package:flutter/material.dart';
import 'package:flutter_todo/Todo.dart';
import 'package:flutter_todo/Todo_list.dart';
import 'Todo_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: "Todo"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: (list == null) ? Center(child: Text("Add new")) : TodoList(list),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    TodoHelper.todoHelper
        .retrieveData()
        .then((value) => value.forEach((element) {
              setState(() {
                list = List()
                  ..add(Todo(element['id'], element['task'],
                      (element['done'] == 1) ? true : false));
              });
            }));
  }

  var textController = TextEditingController();

  void loadAddDialog() {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Add new"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(controller: textController),
              RaisedButton(onPressed: addTodo, child: Text("Add"))
            ],
          ),
        ));
  }

  void addTodo() {
    if (list == null) {
      Todo todo = Todo(1, textController.text, false);
      list = List()..add(todo);
      TodoHelper.todoHelper.insertTodo(todo);
      setState(() {
        _MyHomePageState();
        textController.clear();
        Navigator.of(context).pop();
      });
    } else {
      setState(() {
        Todo todo = Todo(list.length++, textController.text, false);
        this.list.add(todo);
        TodoHelper.todoHelper.insertTodo(todo);
        textController.clear();
        Navigator.of(context).pop();
      });
    }
  }
}

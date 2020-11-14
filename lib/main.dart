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
  List<Todo> list = List()..add(Todo(0, "default", false));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Visibility(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 5, 15),
              child: RaisedButton(
                color: Colors.lightBlueAccent,
                child: Text(
                  'Clear All',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: clear,
              ),
            ),
            visible: (list.length > 3) ? true : false,
          )
        ],
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
    this.list.clear();
    TodoHelper.todoHelper.retrieveData().then((value) {
      setState(() {
        value.forEach((element) {
          list.add(Todo(element['id'], element['task'],
              (element['done'] == 1) ? true : false));
        });
      });
    });
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
    setState(() {
      Todo todo = Todo(list.length + 1, textController.text, false);
      this.list.add(todo);
      TodoHelper.todoHelper.insertTodo(todo);
      textController.clear();
      Navigator.of(context).pop();
    });
    print(TodoHelper.todoHelper.retrieveData());
  }

  void clear() {
    TodoHelper.todoHelper.clearData();
    setState(() {
      this.list.clear();
    });
    print(TodoHelper.todoHelper.retrieveData());
  }
}

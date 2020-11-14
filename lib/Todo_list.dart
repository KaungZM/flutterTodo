import 'package:flutter/material.dart';
import 'package:flutter_todo/main.dart';
import 'Todo_helper.dart';
import 'Todo.dart';

class TodoList extends StatefulWidget {
  final List<Todo> list;
  TodoList(this.list);
  @override
  _TodoListState createState() => _TodoListState(this.list);
}

class _TodoListState extends State<TodoList> {
  List<Todo> list;
  _TodoListState(this.list);
  @override
  Widget build(BuildContext context) {
    if (this.list.length == 0) {
      return Center(child: Text("Add new"));
    } else {
      return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, position) {
            return Row(
              children: [
                Icon(
                  Icons.list_alt,
                  size: 50,
                ),
                Expanded(
                  child: Text(this.list[position].task),
                ),
                Checkbox(
                    value: this.list[position].done,
                    onChanged: (b) => {setDone(position)}),
                RaisedButton(
                    child: Text("Delete"), onPressed: () => {delete(position)})
              ],
            );
          });
    }
  }

  setDone(int position) {
    setState(() {
      this.list[position].done = !this.list[position].done;
      TodoHelper.todoHelper.updateTodo(this.list[position]);
    });
    print(TodoHelper.todoHelper.retrieveData());
  }

  delete(int position) {
    setState(() {
      TodoHelper.todoHelper.deleteTodo(this.list[position].id);
      this.list.removeAt(position);
      MyHomePage();
      if (this.list.length == 0) {
        _TodoListState(this.list);
      }
    });
    print(TodoHelper.todoHelper.retrieveData());
  }
}

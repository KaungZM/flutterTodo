import 'package:flutter/material.dart';

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
    });
  }

  delete(int position) {
    setState(() {
      this.list.removeAt(position);
      if (this.list.length == 0) {
        _TodoListState(this.list);
      }
    });
  }
}

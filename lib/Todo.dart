class Todo {
  int id;
  String task;
  bool done;

  Todo(this.id, this.task, this.done);
  Map<String, dynamic> toMap() {
    return {'id': id, 'task': task, 'done': (done)? 1:0};
  }
}

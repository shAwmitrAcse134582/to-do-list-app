import 'package:flutter/material.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<Map<String, String>> _tasks = [];
  final List<Map<String, String>> _filteredTasks = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredTasks.addAll(_tasks);
    _searchController.addListener(_filterTasks);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTasks);
    _searchController.dispose();
    super.dispose();
  }

  void _filterTasks() {
    setState(() {
      _filteredTasks.clear();
      _filteredTasks.addAll(_tasks.where((task) {
        final name = task['name']!.toLowerCase();
        final phone = task['phone']!;
        final search = _searchController.text.toLowerCase();
        return name.contains(search) || phone.contains(search);
      }).toList());
    });
  }

  void _addTask() {
    setState(() {
      final task = {
        "name": _nameController.text,
        "phone": _phoneController.text,
        "task": _taskController.text,
      };
      _tasks.add(task);
      _filteredTasks.add(task);
      _nameController.clear();
      _phoneController.clear();
      _taskController.clear();
    });
  }

  void _deleteTask(int index) {
    setState(() {
      final task = _filteredTasks[index];
      _tasks.remove(task);
      _filteredTasks.removeAt(index);
    });
  }

  void _editTask(int index, Map<String, String> updatedTask) {
    setState(() {
      final task = _filteredTasks[index];
      final taskIndex = _tasks.indexOf(task);
      _tasks[taskIndex] = updatedTask;
      _filteredTasks[index] = updatedTask;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do List"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or phone',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredTasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_filteredTasks[index]["name"]!),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Phone: ${_filteredTasks[index]["phone"]}"),
                Text("Task: ${_filteredTasks[index]["task"]}"),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _nameController.text = _filteredTasks[index]["name"]!;
                    _phoneController.text = _filteredTasks[index]["phone"]!;
                    _taskController.text = _filteredTasks[index]["task"]!;
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Edit Task"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(labelText: "Name"),
                              ),
                              TextField(
                                controller: _phoneController,
                                decoration: InputDecoration(labelText: "Phone"),
                              ),
                              TextField(
                                controller: _taskController,
                                decoration: InputDecoration(labelText: "Task"),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text("Save"),
                              onPressed: () {
                                _editTask(index, {
                                  "name": _nameController.text,
                                  "phone": _phoneController.text,
                                  "task": _taskController.text,
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteTask(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _nameController.clear();
          _phoneController.clear();
          _taskController.clear();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Add Task"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: "Name"),
                    ),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: "Phone"),
                    ),
                    TextField(
                      controller: _taskController,
                      decoration: InputDecoration(labelText: "Task"),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("Add"),
                    onPressed: () {
                      _addTask();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

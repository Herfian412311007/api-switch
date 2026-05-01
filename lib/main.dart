import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/user.dart';
import 'models/todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas API Switch',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SwitchPage(),
    );
  }
}

class SwitchPage extends StatefulWidget {
  const SwitchPage({super.key});

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {
  bool showUsers = true; // default tampil User

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showUsers ? "User List" : "Todo List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: () {
              setState(() {
                showUsers = !showUsers;
              });
            },
          ),
        ],
      ),
      body: showUsers ? _buildUserList() : _buildTodoList(),
    );
  }

  Widget _buildUserList() {
    return FutureBuilder<List<User>>(
      future: ApiService().fetchUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(child: Text(user.id.toString())),
                  title: Text(user.name),
                  subtitle: Text("${user.username} • ${user.email}"),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text("No user data"));
        }
      },
    );
  }

  Widget _buildTodoList() {
    return FutureBuilder<List<Todo>>(
      future: ApiService().fetchTodos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          final todos = snapshot.data!;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(child: Text(todo.id.toString())),
                  title: Text(todo.title),
                  subtitle: Text("User: ${todo.userId}"),
                  trailing: Icon(
                    todo.completed ? Icons.check_circle : Icons.cancel,
                    color: todo.completed ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text("No todo data"));
        }
      },
    );
  }
}

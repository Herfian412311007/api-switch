import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/todo.dart';

class ApiService {
  static const String baseUrl = "https://jsonplaceholder.typicode.com";

  Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/users"),
        headers: {"Accept": "application/json", "User-Agent": "FlutterApp/1.0"},
      );

      print("Users status: ${response.statusCode}");

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        // fallback dummy data
        return [
          User(
            id: 1,
            name: "Dummy User",
            username: "dummy",
            email: "dummy@mail.com",
          ),
          User(
            id: 2,
            name: "Backup User",
            username: "backup",
            email: "backup@mail.com",
          ),
        ];
      }
    } catch (e) {
      print("Error fetchUsers: $e");
      return [
        User(
          id: 99,
          name: "Offline Mode",
          username: "offline",
          email: "offline@mail.com",
        ),
      ];
    }
  }

  Future<List<Todo>> fetchTodos() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/todos"),
        headers: {"Accept": "application/json", "User-Agent": "FlutterApp/1.0"},
      );

      print("Todos status: ${response.statusCode}");

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Todo.fromJson(json)).toList();
      } else {
        // fallback dummy data
        return [
          Todo(userId: 1, id: 1, title: "Dummy Todo", completed: false),
          Todo(userId: 2, id: 2, title: "Backup Todo", completed: true),
        ];
      }
    } catch (e) {
      print("Error fetchTodos: $e");
      return [
        Todo(userId: 99, id: 99, title: "Offline Mode Todo", completed: false),
      ];
    }
  }
}

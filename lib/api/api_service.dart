import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static String get getUri {
    if (Platform.isIOS) {
      return "http://192.168.0.221:3000";
    } else {
      return "http://10.0.2.2:3000";
    }
  }

  static String? token;

  static Future<bool> login(String username) async {
    final url = Uri.parse("$getUri/auth/login");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data["id"] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt("userId", data["id"]);
        }

        if (data["accessToken"] != null) {
          final prefs = await SharedPreferences.getInstance();
          token = data["accessToken"];
          await prefs.setString("username", data["accessToken"]);
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<List<dynamic>> posts() async {
    final url = Uri.parse("$getUri/posts");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    } else {
      throw Exception("Failed to load posts");
    }
  }

  static Future<bool> likes(int postId) async {
    final url = Uri.parse("$getUri/posts/$postId/likes");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<bool> deleate(int postId) async {
    final url = Uri.parse("$getUri/posts/$postId/likes");
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
    return response.statusCode == 200;
  }

  static Future<Map<String, dynamic>> comments(int id, String text) async {
    final url = Uri.parse("$getUri/posts/$id/comments");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode({"text": text}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error adding comment");
    }
  }
}

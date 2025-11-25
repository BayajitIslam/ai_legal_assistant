// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:template/features/home/models/chat_models.dart';

class ApiService {
  // ==================== CONFIGURATION ====================

  /// TODO: Replace with your actual backend URL
  static const String baseUrl = 'https://your-backend-url.com/api';

  /// TODO: Set your auth token (from login/storage)
  static String? _authToken;

  static void setAuthToken(String token) {
    _authToken = token;
  }

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  // ==================== CHAT SESSIONS ====================

  /// Get all chat sessions
  /// Backend endpoint: GET /chat-sessions
  static Future<List<ChatSessionModel>> getChatSessions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chat-sessions'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> sessions = data['sessions'] ?? data['data'] ?? [];

        return sessions
            .map((e) => ChatSessionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException('Failed to load sessions: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API Error (getChatSessions): $e');
      rethrow;
    }
  }

  /// Create new chat session
  /// Backend endpoint: POST /chat-sessions
  /// Body: { "title": "New Chat" }
  static Future<ChatSessionModel> createChatSession({String? title}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat-sessions'),
        headers: _headers,
        body: json.encode({'title': title ?? 'New Chat'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return ChatSessionModel.fromJson(data['session'] ?? data);
      } else {
        throw ApiException('Failed to create session: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API Error (createChatSession): $e');
      rethrow;
    }
  }

  /// Delete chat session
  /// Backend endpoint: DELETE /chat-sessions/:id
  static Future<void> deleteChatSession(String sessionId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/chat-sessions/$sessionId'),
        headers: _headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException('Failed to delete session: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API Error (deleteChatSession): $e');
      rethrow;
    }
  }

  /// Rename chat session
  /// Backend endpoint: PATCH /chat-sessions/:id
  /// Body: { "title": "New Title" }
  static Future<ChatSessionModel> renameChatSession(
    String sessionId,
    String newTitle,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/chat-sessions/$sessionId'),
        headers: _headers,
        body: json.encode({'title': newTitle}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ChatSessionModel.fromJson(data['session'] ?? data);
      } else {
        throw ApiException('Failed to rename session: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API Error (renameChatSession): $e');
      rethrow;
    }
  }

  // ==================== MESSAGES ====================

  /// Get messages for a session
  /// Backend endpoint: GET /chat-sessions/:id/messages
  static Future<List<MessageModel>> getMessages(String sessionId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chat-sessions/$sessionId/messages'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> messages = data['messages'] ?? data['data'] ?? [];

        return messages
            .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException('Failed to load messages: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API Error (getMessages): $e');
      rethrow;
    }
  }

  /// Send message and get AI response
  /// Backend endpoint: POST /chat-sessions/:id/messages
  /// Body: { "content": "user message" }
  /// Returns: { "user_message": {...}, "ai_response": {...} }
  static Future<Map<String, MessageModel>> sendMessage({
    required String sessionId,
    required String content,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat-sessions/$sessionId/messages'),
        headers: _headers,
        body: json.encode({'content': content}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        return {
          'user_message': MessageModel.fromJson(data['user_message']),
          'ai_response': MessageModel.fromJson(data['ai_response']),
        };
      } else {
        throw ApiException('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API Error (sendMessage): $e');
      rethrow;
    }
  }

  /// Create session with first message (combined endpoint)
  /// Backend endpoint: POST /chat-sessions/with-message
  /// Body: { "content": "first message" }
  /// Returns: { "session": {...}, "user_message": {...}, "ai_response": {...} }
  static Future<Map<String, dynamic>> createChatWithMessage(
    String content,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat-sessions/with-message'),
        headers: _headers,
        body: json.encode({'content': content}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        return {
          'session': ChatSessionModel.fromJson(data['session']),
          'user_message': MessageModel.fromJson(data['user_message']),
          'ai_response': MessageModel.fromJson(data['ai_response']),
        };
      } else {
        throw ApiException('Failed to create chat: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ API Error (createChatWithMessage): $e');
      rethrow;
    }
  }
}

// ==================== EXCEPTION CLASS ====================

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

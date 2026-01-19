// lib/models/chat_models.dart
// ✅ UPDATED TO HANDLE API JSON FORMAT

class MessageModel {
  final String id;
  final String content;
  final bool isUser; // true = user, false = assistant
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
  });

  /// ✅ Parse from API response format
  factory MessageModel.fromApiJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      isUser: json['role'] == 'user', // API uses 'role' field
      timestamp: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  /// Parse from local storage format
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      isUser: json['is_user'] ?? true,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  /// Convert to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'is_user': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class ChatSessionModel {
  final String id;
  String title;
  final List<MessageModel> messages;
  final DateTime createdAt;
  DateTime updatedAt;
  final bool isActive;
  final int messageCount;

  ChatSessionModel({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.messageCount = 0,
  });

  /// ✅ Parse from API response format
  factory ChatSessionModel.fromApiJson(Map<String, dynamic> json) {
    return ChatSessionModel(
      id: json['id'] ?? '',
      title: json['title'] ?? 'New Chat',
      messages: json['messages'] != null
          ? (json['messages'] as List)
                .map((m) => MessageModel.fromApiJson(m as Map<String, dynamic>))
                .toList()
          : [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      isActive: json['is_active'] ?? true,
      messageCount: json['message_count'] ?? 0,
    );
  }

  /// Parse from local storage format
  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    return ChatSessionModel(
      id: json['id'] ?? '',
      title: json['title'] ?? 'New Chat',
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      isActive: json['is_active'] ?? true,
      messageCount: json['message_count'] ?? 0,
    );
  }

  /// Convert to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((m) => m.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
      'message_count': messageCount,
    };
  }

  /// Create a copy with updated fields
  ChatSessionModel copyWith({
    String? id,
    String? title,
    List<MessageModel>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    int? messageCount,
  }) {
    return ChatSessionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      messageCount: messageCount ?? this.messageCount,
    );
  }
}

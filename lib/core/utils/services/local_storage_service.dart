import 'package:get_storage/get_storage.dart';
import 'package:template/features/home/models/chat_models.dart';

class LocalStorageService {
  static const String _chatSessionsKey = 'chat_sessions';
  static final GetStorage _box = GetStorage();

  /// Initialize GetStorage
  static Future<void> init() async {
    await GetStorage.init();
  }

  /// Save all chat sessions to local storage
  static Future<void> saveChatSessions(List<ChatSessionModel> sessions) async {
    final jsonList = sessions.map((s) => s.toJson()).toList();
    await _box.write(_chatSessionsKey, jsonList);
  }

  /// Load all chat sessions from local storage
  static List<ChatSessionModel> loadChatSessions() {
    final data = _box.read<List<dynamic>>(_chatSessionsKey);
    if (data == null) return [];

    return data
        .map((e) => ChatSessionModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Clear all chat sessions
  static Future<void> clearAllSessions() async {
    await _box.remove(_chatSessionsKey);
  }
}

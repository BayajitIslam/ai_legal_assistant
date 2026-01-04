// lib/controllers/chat_controller.dart
// COMPLETE FILE with sorting functionality

import 'package:get/get.dart';
import 'package:template/core/utils/services/ai_service.dart';
import 'package:template/core/utils/services/local_storage_service.dart';
import 'package:template/features/widget/custome_snackbar.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import '../models/chat_models.dart';

class ChatController extends GetxController {
  final RxList<ChatSessionModel> chatSessions = <ChatSessionModel>[].obs;
  final Rx<ChatSessionModel?> currentSession = Rx<ChatSessionModel?>(null);
  final RxBool isLoading = false.obs;

  final _uuid = const Uuid();

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    final savedSessions = LocalStorageService.loadChatSessions();
    chatSessions.value = savedSessions;

    if (savedSessions.isNotEmpty) {
      // Sort by most recent first
      _sortChatSessionsByRecent();
      currentSession.value = savedSessions.first;
    }
  }

  /// ✅ Sort chat sessions by most recent message/update (newest first)
  void _sortChatSessionsByRecent() {
    chatSessions.sort((a, b) {
      // Use updatedAt for comparison (updated when message sent or session selected)
      return b.updatedAt.compareTo(a.updatedAt);
    });
  }

  /// Get formatted time for message
  String getFormattedTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Get current messages for display
  List<MessageModel> get currentMessages {
    return currentSession.value?.messages ?? [];
  }

  /// Create new chat session
  void createNewChat() {
    final newSession = ChatSessionModel(
      id: _uuid.v4(),
      title: 'New Chat ${chatSessions.length + 1}',
      messages: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    chatSessions.insert(0, newSession); // Insert at top
    currentSession.value = newSession;

    LocalStorageService.saveChatSessions(chatSessions);

    // Close drawer if open
    if (Get.context != null) {
      final scaffoldState = Scaffold.maybeOf(Get.context!);
      if (scaffoldState != null && scaffoldState.isDrawerOpen) {
        Get.back();
      }
    }
  }

  /// Select a chat session
  void selectChatSession(ChatSessionModel session) {
    currentSession.value = session;

    // Update timestamp to bring it to top
    session.updatedAt = DateTime.now();

    // Re-sort to move selected chat to top
    _sortChatSessionsByRecent();

    LocalStorageService.saveChatSessions(chatSessions);

    // Close drawer
    if (Get.context != null) {
      final scaffoldState = Scaffold.maybeOf(Get.context!);
      if (scaffoldState != null && scaffoldState.isDrawerOpen) {
        Get.back();
      }
    }
  }

  /// Send message and get AI response
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Create new chat if none exists
    if (currentSession.value == null) {
      createNewChat();
    }

    // Create user message
    final userMessage = MessageModel(
      id: _uuid.v4(),
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Add to current session
    currentSession.value!.messages.add(userMessage);
    currentSession.value!.updatedAt = DateTime.now(); // Update timestamp
    currentSession.refresh();

    // Save immediately
    LocalStorageService.saveChatSessions(chatSessions);

    isLoading.value = true;

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Get AI response
      final aiResponse = await AIService.getResponse(message);

      // Create AI message
      final aiMessage = MessageModel(
        id: _uuid.v4(),
        content: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
      );

      // Add AI message
      currentSession.value!.messages.add(aiMessage);
      currentSession.value!.updatedAt =
          DateTime.now(); // Update timestamp again
      currentSession.refresh();

      // Sort sessions - most recent chat goes to top
      _sortChatSessionsByRecent();

      // Save to storage
      LocalStorageService.saveChatSessions(chatSessions);
    } catch (e) {
      print('Error getting AI response: $e');

      CustomeSnackbar.error('Failed to get response. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Rename chat session
  void renameChatSession(String sessionId, String newTitle) {
    final index = chatSessions.indexWhere((s) => s.id == sessionId);
    if (index != -1) {
      chatSessions[index].title = newTitle;
      chatSessions[index].updatedAt = DateTime.now();

      // Sort after rename
      _sortChatSessionsByRecent();

      LocalStorageService.saveChatSessions(chatSessions);
      Get.back();
      CustomeSnackbar.success('Chat renamed successfully');
    } else {
      print('Chat session not found');
    }
  }

  /// Delete chat session
  void deleteChatSession(String sessionId) {
    chatSessions.removeWhere((s) => s.id == sessionId);

    // If deleted current session, select first one or null
    if (currentSession.value?.id == sessionId) {
      currentSession.value = chatSessions.isNotEmpty
          ? chatSessions.first
          : null;
    }

    LocalStorageService.saveChatSessions(chatSessions);
    Get.back();
    CustomeSnackbar.success('Chat deleted successfully');
  }
}

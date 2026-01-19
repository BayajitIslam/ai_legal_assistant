import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:template/core/constants/api_endpoints.dart';
import 'package:template/core/services/api_service.dart';
import 'package:template/core/services/local%20storage/storage_service.dart';
import 'package:template/core/utils/console.dart';
import 'package:template/features/widget/custome_snackbar.dart';
import '../models/chat_models.dart';

class ChatController extends GetxController {
  // ═══════════════════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════════════════

  final RxList<ChatSessionModel> chatSessions = <ChatSessionModel>[].obs;
  final Rx<ChatSessionModel?> currentSession = Rx<ChatSessionModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoadingSessions = false.obs;

  // ═══════════════════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void onInit() {
    super.onInit();
    loadChatSessions();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOAD CHAT SESSIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Load all chat sessions from API
  Future<void> loadChatSessions() async {
    Console.info('Loading chat sessions...');
    Console.info(
      'Check if user is logged in... ${StorageService.getAccessTokenString()}',
    );
    try {
      isLoadingSessions.value = true;

      final response = await ApiService.getAuth(ApiEndpoints.getChatSessions);

      if (response.success && response.data != null) {
        final sessions = (response.data['data']['sessions'] as List)
            .map((json) => ChatSessionModel.fromApiJson(json))
            .toList();

        chatSessions.value = sessions;

        // Set first session as current if none selected
        if (currentSession.value == null && sessions.isNotEmpty) {
          currentSession.value = sessions.first;
          // Load messages for current session
          await loadSessionMessages(sessions.first.id);
        }
      }
    } catch (e) {
      Console.error('Error loading sessions: $e');
      CustomeSnackbar.error('Failed to load chat history');
    } finally {
      isLoadingSessions.value = false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CREATE NEW CHAT SESSION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Create new empty chat session
  Future<void> createNewChat() async {
    try {
      isLoading.value = true;

      final response = await ApiService.postAuth(
        ApiEndpoints.createChatSession,
      );

      if (response.success && response.data != null) {
        final newSession = ChatSessionModel.fromApiJson(
          response.data['data']['session'],
        );

        // Add to top of list
        chatSessions.insert(0, newSession);
        currentSession.value = newSession;

        Console.info('Created new chat session: ${newSession.id}');
        // Close drawer
        _closeDrawer();
      } else {
        CustomeSnackbar.error('Failed to create new chat');
      }
    } catch (e) {
      Console.error('Error creating chat: $e');
      CustomeSnackbar.error('Failed to create new chat');
    } finally {
      isLoading.value = false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOAD SESSION MESSAGES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Load all messages for a specific session
  Future<void> loadSessionMessages(String sessionId) async {
    try {
      final response = await ApiService.getAuth(
        ApiEndpoints.getChatSession(sessionId),
      );

      if (response.success && response.data != null) {
        final sessionData = response.data['data']['session'];

        // Update current session with messages
        if (currentSession.value?.id == sessionId) {
          final messages = (sessionData['messages'] as List)
              .map((json) => MessageModel.fromApiJson(json))
              .toList();

          currentSession.value = currentSession.value!.copyWith(
            messages: messages,
          );
        }
      }
    } catch (e) {
      Console.error('Error loading messages: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SELECT CHAT SESSION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Select a chat session and load its messages
  Future<void> selectChatSession(ChatSessionModel session) async {
    currentSession.value = session;

    // Load messages if not already loaded
    if (session.messages.isEmpty) {
      await loadSessionMessages(session.id);
    }

    // Close drawer
    _closeDrawer();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SEND MESSAGE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Send message to AI and get response
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Create new session if none exists
    if (currentSession.value == null) {
      await createNewChat();
      if (currentSession.value == null) return; // Creation failed
    }

    // Create user message (optimistic UI)
    final userMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Temp ID
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Add to UI immediately
    currentSession.value!.messages.add(userMessage);
    currentSession.refresh();

    isLoading.value = true;

    try {
      // Prepare conversation history
      final conversationHistory = currentSession.value!.messages
          .take(
            currentSession.value!.messages.length - 1,
          ) // Exclude last (just added)
          .map(
            (msg) => {
              'role': msg.isUser ? 'user' : 'assistant',
              'content': msg.content,
            },
          )
          .toList();

      // Send to API
      final response = await ApiService.postAuth(
        ApiEndpoints.sendMessage,
        body: {'message': message, 'conversation_history': conversationHistory},
      );

      if (response.success && response.data != null) {
        final data = response.data['data'];

        // Update user message with real ID
        final userMessageData = data['user_message'];
        final realUserMessage = MessageModel.fromApiJson(userMessageData);

        // Replace temp user message with real one
        currentSession.value!.messages.removeLast();
        currentSession.value!.messages.add(realUserMessage);

        // Add AI response
        final aiMessageData = data['assistant_message'];
        final aiMessage = MessageModel.fromApiJson(aiMessageData);
        currentSession.value!.messages.add(aiMessage);

        // Update session title if it's the first message
        if (data['session_title'] != null) {
          currentSession.value!.title = data['session_title'];

          // Update in list
          final index = chatSessions.indexWhere(
            (s) => s.id == currentSession.value!.id,
          );
          if (index != -1) {
            chatSessions[index].title = data['session_title'];
          }
        }

        // Move session to top
        _moveSessionToTop(currentSession.value!);

        currentSession.refresh();
      } else {
        // Remove optimistic user message on error
        currentSession.value!.messages.removeLast();
        currentSession.refresh();
        CustomeSnackbar.error('Failed to send message');
      }
    } catch (e) {
      Console.error('Error sending message: $e');
      // Remove optimistic user message on error
      currentSession.value!.messages.removeLast();
      currentSession.refresh();
      CustomeSnackbar.error('Failed to send message');
    } finally {
      isLoading.value = false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RENAME SESSION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Rename chat session
  Future<void> renameChatSession(String sessionId, String newTitle) async {
    try {
      final response = await ApiService.patchAuth(
        ApiEndpoints.updateChatSession(sessionId),
        body: {'title': newTitle},
      );

      if (response.success) {
        // Update locally
        final index = chatSessions.indexWhere((s) => s.id == sessionId);
        if (index != -1) {
          chatSessions[index].title = newTitle;
          chatSessions.refresh();
        }

        if (currentSession.value?.id == sessionId) {
          currentSession.value!.title = newTitle;
          currentSession.refresh();
        }

        Get.back(); // Close dialog
        CustomeSnackbar.success('Chat renamed successfully');
      } else {
        CustomeSnackbar.error('Failed to rename chat');
      }
    } catch (e) {
      Console.error('Error renaming session: $e');
      CustomeSnackbar.error('Failed to rename chat');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DELETE SESSION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Delete chat session
  Future<void> deleteChatSession(String sessionId) async {
    try {
      final response = await ApiService.deleteAuth(
        ApiEndpoints.deleteChatSession(sessionId),
      );

      if (response.success) {
        // Remove from list
        chatSessions.removeWhere((s) => s.id == sessionId);

        // If deleted current session, select first available
        if (currentSession.value?.id == sessionId) {
          currentSession.value = chatSessions.isNotEmpty
              ? chatSessions.first
              : null;

          // Load messages for new current session
          if (currentSession.value != null) {
            await loadSessionMessages(currentSession.value!.id);
          }
        }

        Get.back(); // Close dialog
        CustomeSnackbar.success('Chat deleted successfully');
      } else {
        CustomeSnackbar.error('Failed to delete chat');
      }
    } catch (e) {
      Console.error('Error deleting session: $e');
      CustomeSnackbar.error('Failed to delete chat');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════════════

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

  /// Move session to top of list
  void _moveSessionToTop(ChatSessionModel session) {
    chatSessions.remove(session);
    chatSessions.insert(0, session);
  }

  /// Close drawer if open
  void _closeDrawer() {
    if (Get.context != null) {
      final scaffoldState = Scaffold.maybeOf(Get.context!);
      if (scaffoldState != null && scaffoldState.isDrawerOpen) {
        Get.back();
      }
    }
  }
}

import 'package:ai_legal_assistant/core/constants/api_endpoints.dart';
import 'package:ai_legal_assistant/core/services/api_service.dart';
import 'package:ai_legal_assistant/core/utils/console.dart';
import 'package:ai_legal_assistant/features/widget/custome_snackbar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/chat_models.dart';

class ChatController extends GetxController {
  // State
  final RxList<ChatSessionModel> chatSessions = <ChatSessionModel>[].obs;
  final Rx<ChatSessionModel?> currentSession = Rx<ChatSessionModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoadingSessions = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadChatSessions();
    // Don't auto-select first session
    // currentSession stays null until user sends message or selects session
  }

  /// Load all chat sessions from API
  Future<void> loadChatSessions() async {
    Console.info('Loading chat sessions...');
    try {
      isLoadingSessions.value = true;

      final response = await ApiService.getAuth(ApiEndpoints.getChatSessions);

      if (response.success && response.data != null) {
        final sessions = (response.data['data']['sessions'] as List)
            .map((json) => ChatSessionModel.fromApiJson(json))
            .toList();

        chatSessions.value = sessions;
        Console.info('Loaded ${sessions.length} sessions');

        // Don't auto-select first session
        // Let user start with empty chat or select from drawer
      }
    } catch (e) {
      Console.error('Error loading sessions: $e');
      CustomeSnackbar.error('Failed to load chat history');
    } finally {
      isLoadingSessions.value = false;
    }
  }

  /// Create new empty chat (clears current session, backend session created on first message)
  Future<void> createNewChat() async {
    // Simply clear current session - no backend call
    // Backend session will be created when user sends first message
    currentSession.value = null;
    Console.info('Cleared current session for new chat');
    _closeDrawer();
  }

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

  /// Select a chat session from drawer
  Future<void> selectChatSession(ChatSessionModel session) async {
    currentSession.value = session;

    // Load messages if not already loaded
    if (session.messages.isEmpty) {
      await loadSessionMessages(session.id);
    }

    _closeDrawer();
  }

  /// Send message to AI and get response
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Create user message for optimistic UI
    final userMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // If no current session, create temporary list for optimistic UI
    if (currentSession.value == null) {
      // Create temporary session for UI display
      currentSession.value = ChatSessionModel(
        id: '', // Empty ID - will be filled by backend response
        title: 'New Chat',
        messages: [userMessage],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: true,
        messageCount: 0,
      );
    } else {
      // Add to existing session
      currentSession.value!.messages.add(userMessage);
    }

    currentSession.refresh();

    isLoading.value = true;

    try {
      Console.info('Sending message...');
      Console.info('Message: $message');
      Console.info('Current session ID: ${currentSession.value?.id}');

      // Prepare request body
      // session_id will be null for first message (empty string or null)
      final String? sessionId = currentSession.value?.id.isNotEmpty == true
          ? currentSession.value?.id
          : null;

      final Map<String, dynamic> requestBody = {
        'message': message,
        'session_id': sessionId,
      };

      Console.info('Request body: $requestBody');

      // Send to API
      final response = await ApiService.postAuth(
        ApiEndpoints.sendMessage,
        body: requestBody,
      );

      Console.info('Response status: ${response.statusCode}');

      if (response.success && response.data != null) {
        final data = response.data['data'];
        final backendSessionId = data['session_id'];

        Console.info('Backend session ID: $backendSessionId');

        // Update current session with backend session ID
        if (currentSession.value != null) {
          // Check if this is a new session
          if (currentSession.value!.id.isEmpty) {
            Console.info('New session created by backend');

            // Update session ID
            currentSession.value = ChatSessionModel(
              id: backendSessionId,
              title: data['session_title'] ?? 'New Chat',
              messages: [],
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              isActive: true,
              messageCount: 0,
            );

            // Add to sessions list
            chatSessions.insert(0, currentSession.value!);
          }

          // Remove temp user message (check if not empty to avoid RangeError)
          if (currentSession.value!.messages.isNotEmpty) {
            currentSession.value!.messages.removeLast();
          }

          // Add real messages from backend
          final userMessageData = data['user_message'];
          final realUserMessage = MessageModel.fromApiJson(userMessageData);
          currentSession.value!.messages.add(realUserMessage);

          final aiMessageData = data['assistant_message'];
          final aiMessage = MessageModel.fromApiJson(aiMessageData);
          currentSession.value!.messages.add(aiMessage);

          // Update session title
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
          Console.success('Message sent successfully');
        }
      } else {
        // Remove optimistic message on error
        if (currentSession.value != null) {
          if (currentSession.value!.messages.isNotEmpty) {
            currentSession.value!.messages.removeLast();
          }

          // If was temporary session, clear it
          if (currentSession.value!.id.isEmpty) {
            currentSession.value = null;
          }

          currentSession.refresh();
        }
        CustomeSnackbar.error('Failed to send message');
      }
    } catch (e) {
      Console.error('Error sending message: $e');

      // Remove optimistic message on error
      if (currentSession.value != null) {
        if (currentSession.value!.messages.isNotEmpty) {
          currentSession.value!.messages.removeLast();
        }

        // If was temporary session, clear it
        if (currentSession.value!.id.isEmpty) {
          currentSession.value = null;
        }

        currentSession.refresh();
      }
      CustomeSnackbar.error('Failed to send message');
    } finally {
      isLoading.value = false;
    }
  }

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

        Get.back();
        CustomeSnackbar.success('Chat renamed successfully');
      } else {
        CustomeSnackbar.error('Failed to rename chat');
      }
    } catch (e) {
      Console.error('Error renaming session: $e');
      CustomeSnackbar.error('Failed to rename chat');
    }
  }

  /// Delete chat session
  Future<void> deleteChatSession(String sessionId) async {
    try {
      final response = await ApiService.deleteAuth(
        ApiEndpoints.deleteChatSession(sessionId),
      );

      if (response.success) {
        // Remove from list
        chatSessions.removeWhere((s) => s.id == sessionId);

        // If deleted current session, clear current session
        if (currentSession.value?.id == sessionId) {
          currentSession.value = null;
        }

        Get.back();
        CustomeSnackbar.success('Chat deleted successfully');
      } else {
        CustomeSnackbar.error('Failed to delete chat');
      }
    } catch (e) {
      Console.error('Error deleting session: $e');
      CustomeSnackbar.error('Failed to delete chat');
    }
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

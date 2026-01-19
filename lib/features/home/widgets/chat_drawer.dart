import 'package:ai_legal_assistant/core/constants/app_colors.dart';
import 'package:ai_legal_assistant/core/themes/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import '../models/chat_models.dart';

class ChatDrawer extends GetView<ChatController> {
  const ChatDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header with close button
            _buildHeader(context),

            // New Chat Button
            _buildNewChatButton(),

            // All Chats History Label
            _buildHistoryLabel(),

            // Chat Sessions List
            Expanded(child: _buildChatSessionsList()),

            // User Profile Section at bottom
            // _buildUserProfileSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close,
              color: Color(0xFFE87B35), // Orange color from your design
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewChatButton() {
    return InkWell(
      onTap: () {
        Get.back();
        controller.createNewChat();
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bg,
          boxShadow: [
            BoxShadow(
              color: const Color(0x40000000),
              blurRadius: 4,
              offset: Offset(0, 0),
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Center(
          child: Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                color: Colors.grey[700],
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'New chat',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryLabel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'All Chats History',
          style: AppTextStyles.s14w4i(
            fontSize: 15,
            color: const Color(0xFF838383),
          ),
        ),
      ),
    );
  }

  Widget _buildChatSessionsList() {
    return Obx(() {
      if (controller.chatSessions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 48,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                'No chat history yet',
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Start a new chat to begin',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.chatSessions.length,
        itemBuilder: (context, index) {
          final session = controller.chatSessions[index];
          return _buildChatSessionItem(session);
        },
      );
    });
  }

  Widget _buildChatSessionItem(ChatSessionModel session) {
    return Obx(() {
      final isSelected = controller.currentSession.value?.id == session.id;

      return Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF3ED) : Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: const Color(0x40000000),
              blurRadius: 4,
              offset: Offset(0, 0),
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        margin: EdgeInsets.only(bottom: 10.h),
        child: ListTile(
          dense: true,
          visualDensity: VisualDensity(vertical: -2),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
          onTap: () {
            Get.back();
            controller.selectChatSession(session);
          },
          title: Text(
            session.title,
            style: AppTextStyles.s16w4p(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: AppColors.titleText,
              size: 26.sp,
            ),
            onSelected: (value) {
              switch (value) {
                case 'rename':
                  _showRenameDialog(session);
                  break;
                case 'delete':
                  _showDeleteConfirmation(session);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'rename',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text('Rename'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showRenameDialog(ChatSessionModel session) {
    final textController = TextEditingController(text: session.title);

    Get.dialog(
      AlertDialog(
        title: const Text('Rename Chat'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Enter new name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                Get.back();
                controller.renameChatSession(
                  session.id,
                  textController.text.trim(),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE87B35),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(ChatSessionModel session) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Chat'),
        content: const Text(
          'Are you sure you want to delete this chat? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteChatSession(session.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Widget _buildUserProfileSection() {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       border: Border(top: BorderSide(color: Colors.grey[200]!)),
  //     ),
  //     child: Row(
  //       children: [
  //         // User Avatar
  //         CircleAvatar(
  //           radius: 20,
  //           backgroundColor: Colors.grey[300],
  //           child: const Icon(Icons.person, color: Colors.white),
  //         ),
  //         const SizedBox(width: 12),

  //         // User Info
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 'Kurt Cobain', // Replace with actual user name
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.grey[800],
  //                 ),
  //               ),
  //               Text(
  //                 'Monthly Subscription',
  //                 style: TextStyle(fontSize: 12, color: Colors.grey[500]),
  //               ),
  //             ],
  //           ),
  //         ),

  //         // Upgrade Button
  //         ElevatedButton(
  //           onPressed: () {
  //             // Handle upgrade
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: const Color(0xFFE87B35),
  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //           ),
  //           child: const Text(
  //             'Upgrade',
  //             style: TextStyle(color: Colors.white, fontSize: 12),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

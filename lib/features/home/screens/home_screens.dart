import 'package:ai_legal_assistant/core/constants/app_colors.dart';
import 'package:ai_legal_assistant/core/constants/image_const.dart';
import 'package:ai_legal_assistant/core/themes/app_text_style.dart';
import 'package:ai_legal_assistant/features/widget/custome_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import '../widgets/chat_drawer.dart';
import '../widgets/message_bubble.dart';

class HomeScreens extends GetView<ChatController> {
  HomeScreens({super.key});

  // Global key to control scaffold drawer
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  // Text controller
  final TextEditingController textController = TextEditingController();

  //  Scroll controller for auto-scroll
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const ChatDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomeHeader(
                title: "LegalGPT",
                isHome: true,
                onTapDrawer: () {
                  scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),

            // Messages List
            Expanded(child: _buildMessagesList()),

            // Input Field
            _buildInputField(),

            // Disclaimer
            _buildDisclaimer(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    return Obx(() {
      final messages = controller.currentMessages;
      final isLoading = controller.isLoading.value;

      //  Auto-scroll when messages change
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients && messages.isNotEmpty) {
          _scrollToBottom();
        }
      });

      if (messages.isEmpty && !isLoading) {
        return _buildEmptyState();
      }

      return ListView.builder(
        controller: scrollController, //  Add scroll controller
        padding: const EdgeInsets.symmetric(vertical: 16),
        reverse: false,
        itemCount: messages.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (isLoading && index == messages.length) {
            return const TypingIndicator();
          }

          final message = messages[index];
          final formattedTime = controller.getFormattedTime(message.timestamp);

          if (message.isUser) {
            return UserMessageBubble(
              message: message,
              formattedTime: formattedTime,
            );
          } else {
            return AIMessageBubble(
              message: message,
              formattedTime: formattedTime,
            );
          }
        },
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Center(child: Image.asset(AppImages.legalAiLogo)),
          ),
          const SizedBox(height: 24),
          Text(
            'Welcome to LegalGPT',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ask me any legal question',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        'This AI assistant provides general legal information only.\nConsult a licensed attorney for legal advice.',
        textAlign: TextAlign.center,
        style: AppTextStyles.s14w4i(fontSize: 12, color: AppColors.gray),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.brand,
          borderRadius: BorderRadius.circular(33),
          border: Border.all(color: const Color(0XffFFB991)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    controller.sendMessage(value);
                    textController.clear();
                    _scrollToBottom();
                  }
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Ask LegalGPT',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            Obx(
              () => Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.bg,
                  child: InkWell(
                    onTap: controller.isLoading.value
                        ? null
                        : () {
                            if (textController.text.trim().isNotEmpty) {
                              controller.sendMessage(textController.text);
                              textController.clear();
                              _scrollToBottom();
                            }
                          },
                    child: SvgPicture.asset(
                      AppImages.sendMessage,
                      width: 22,
                      color: controller.isLoading.value
                          ? const Color(0x60EE6C20)
                          : AppColors.brand,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  Smooth scroll to bottom
  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}

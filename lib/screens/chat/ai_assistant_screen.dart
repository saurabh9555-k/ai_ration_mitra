// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(
        text:
            "Hello! I'm your AI Ration Mitra Assistant. How can I help you today?",
        isUser: false,
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: _messageController.text, isUser: true));
      _isTyping = true;
    });
    String userMessage = _messageController.text;
    _messageController.clear();
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _isTyping = false;
        _messages.add(
          ChatMessage(text: _getBotResponse(userMessage), isUser: false),
        );
        _scrollToBottom();
      });
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getBotResponse(String userInput) {
    String input = userInput.toLowerCase().trim();
    if (input.contains('hello') || input.contains('hi')) {
      return "Hello! How can I assist you with your ration needs?";
    }
    if (input.contains('entitlement') || input.contains('ration')) {
      return "To check your monthly ration entitlement, go to the 'Entitlements' tab. You'll see the list of items with collected and pending quantities.";
    }
    if (input.contains('aadhaar')) {
      return "Your Aadhaar is used for secure authentication. It is encrypted and never shared. For any Aadhaar issues, please visit the nearest Seva Kendra.";
    }
    if (input.contains('fps') || input.contains('shop')) {
      return "You can find nearby Fair Price Shops using the 'FPS Locator' tab. It will show shops near your current location with distance and availability.";
    }
    if (input.contains('book') || input.contains('slot')) {
      return "To book a slot for collection, go to the 'Booking' option in Quick Actions. Choose a date and time, and confirm your slot.";
    }
    if (input.contains('history')) {
      return "Your distribution history is available under 'Distribution History'. You can see all past collections and dates.";
    }
    if (input.contains('forgot') || input.contains('password')) {
      return "If you forgot your password, use the 'Forgot Password?' link on the login screen. An OTP will be sent to your registered mobile.";
    }
    if (input.contains('update') || input.contains('new')) {
      return "March 2026 rations are now available for collection. Please check your entitlements and book a slot at your assigned FPS.";
    }
    if (input.contains('contact') || input.contains('support')) {
      return "For any assistance, you can call the helpline: 1800-XXX-XXXX or email support@rationmitra.gov.in.";
    }
    if (input.contains('thanks')) {
      return "You're welcome! If you have more questions, feel free to ask.";
    }
    return "I'm sorry, I didn't understand that. Please ask about entitlements, FPS shops, booking, Aadhaar, or other ration-related topics.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Ration Mitra Assistant'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return const TypingIndicator();
                }
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.saffron,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.saffron,
              child: Icon(Icons.smart_toy, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser ? AppColors.saffron : Colors.grey[300],
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: message.isUser
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: message.isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.green,
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.saffron,
            child: Icon(Icons.smart_toy, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(
                20,
              ).copyWith(bottomLeft: const Radius.circular(4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [0, 400, 800].map((delay) => _buildDot(delay)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, child) => Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        // ignore: duplicate_ignore
        // ignore: deprecated_member_use
        decoration: BoxDecoration(
          color: Colors.black54.withOpacity(value),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

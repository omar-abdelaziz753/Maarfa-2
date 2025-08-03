import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_academy/layout/view/profile/managers/contact_support_service_cubit.dart';
import 'package:my_academy/res/drawable/image/images.dart';
import 'package:my_academy/widget/app_bar/default_app_bar/default_app_bar.dart';

import '../models/contact_support_data_model.dart';

class ContactSupportServiceScreen extends StatefulWidget {
  const ContactSupportServiceScreen({super.key});

  @override
  State<ContactSupportServiceScreen> createState() =>
      _ContactSupportServiceScreenState();
}

class _ContactSupportServiceScreenState
    extends State<ContactSupportServiceScreen> {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  List<QuestionData> _dynamicQuestions = [];
  String _staticMessage =
      "Hello! How can I help you today? Please select one of the questions below:";

  final List<String> _predefinedQuestions = [
    "How can I reset my password?",
    "How do I contact customer service?",
    "Where can I find my order history?",
    "How do I update my profile information?",
    "What are your refund policies?",
    "How can I delete my account?",
  ];

  @override
  void initState() {
    super.initState();
    // Add welcome message
    context.read<ContactSupportServiceCubit>().getAllSupportData();
  }

  // void _sendMessage(String message, int questionNumber) {
  //   setState(() {
  //     // Add user message
  //     _messages.add(ChatMessage(
  //       text: message,
  //       isUser: true,
  //       timestamp: DateTime.now(),
  //     ));
  //
  //     // Add bot response based on question number
  //     String response = _getBotResponse(questionNumber);
  //     _messages.add(ChatMessage(
  //       text: response,
  //       isUser: false,
  //       timestamp: DateTime.now(),
  //     ));
  //   });
  //
  //   // Scroll to bottom
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent,
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeOut,
  //     );
  //   });
  // }
  void _sendMessage(String message, String answer) {
    setState(() {
      // Add user message
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));

      // Add bot response with the answer from API
      _messages.add(ChatMessage(
        text: answer,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _addWelcomeMessage(String message) {
    setState(() {
      _messages.clear(); // Clear any existing messages
      _messages.add(ChatMessage(
        text: message,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  String _getBotResponse(int questionNumber) {
    switch (questionNumber) {
      case 1:
        return "To reset your password, go to the login screen and click 'Forgot Password'. Enter your email and follow the instructions sent to your inbox.";
      case 2:
        return "You can contact our customer service team through this chat, email us at support@myacademy.com, or call us at +1-800-123-4567.";
      case 3:
        return "Your order history can be found in your profile under 'My Orders' section. You can view all past purchases and their status there.";
      case 4:
        return "To update your profile, go to Settings > Profile Information. You can edit your name, email, phone number, and other details there.";
      case 5:
        return "We offer a 30-day refund policy for most purchases. Please contact our support team with your order details for assistance with refunds.";
      case 6:
        return "To delete your account, please contact our support team. Note that this action is permanent and all your data will be removed.";
      default:
        return "Thank you for your question. Our support team will get back to you soon.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: FractionalOffset.topCenter,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            staticBackground,
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar:
              DefaultAppBar(title: tr("contact_support"), centerTitle: false),
          body: BlocConsumer<ContactSupportServiceCubit,
              ContactSupportServiceState>(
            listener: (context, state) {
              if (state is GetAllContactSupportServiceSuccessState) {
                _staticMessage = state.staticMessage;
                _dynamicQuestions = state.data;
                _addWelcomeMessage(_staticMessage);
              } else if (state is GetAllContactSupportServiceErrorState) {
                // Show error message or fallback
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ?? 'Failed to load support data'),
                    backgroundColor: Colors.red,
                  ),
                );
                // Add fallback welcome message
                _addWelcomeMessage(_staticMessage);
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  // Chat messages area
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          // Messages list
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(16),
                              itemCount: _messages.length,
                              itemBuilder: (context, index) {
                                return _buildMessageBubble(_messages[index]);
                              },
                            ),
                          ),
                          // Predefined questions
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Quick Questions:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Wrap(
                                //   spacing: 8,
                                //   runSpacing: 8,
                                //   children: _predefinedQuestions
                                //       .asMap()
                                //       .entries
                                //       .map((entry) {
                                //     int index = entry.key + 1;
                                //     String question = entry.value;
                                //     return _buildQuestionChip(question, index);
                                //   }).toList(),
                                // ),
                                if (state is GetAllContactSupportServiceLoadingState)
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                else if (_dynamicQuestions.isNotEmpty)
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _dynamicQuestions.map((questionData) {
                                      return _buildQuestionChip(questionData.question!, questionData.answer!);
                                    }).toList(),
                                  )
                                else
                                  const Text(
                                    "No questions available at the moment.",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[100],
              child: Icon(
                Icons.support_agent,
                size: 18,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blue[500] : Colors.grey[200],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('HH:mm').format(message.timestamp),
                    style: TextStyle(
                      color: message.isUser ? Colors.white70 : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[500],
              child: const Icon(
                Icons.person,
                size: 18,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Widget _buildQuestionChip(String question, int questionNumber) {
  //   return InkWell(
  //     onTap: () => _sendMessage(question, questionNumber),
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //       decoration: BoxDecoration(
  //         color: Colors.blue[50],
  //         borderRadius: BorderRadius.circular(20),
  //         border: Border.all(color: Colors.blue[200]!),
  //       ),
  //       child: Text(
  //         question,
  //         style: TextStyle(
  //           color: Colors.blue[700],
  //           fontSize: 13,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget _buildQuestionChip(String question, String answer) {
    return InkWell(
      onTap: () => _sendMessage(question, answer),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue[200]!),
        ),
        child: Text(
          question,
          style: TextStyle(
            color: Colors.blue[700],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

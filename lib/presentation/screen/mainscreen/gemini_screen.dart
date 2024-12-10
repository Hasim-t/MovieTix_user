import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:movie/presentation/constants/color.dart';

class GeminiScreen extends StatefulWidget {
  const GeminiScreen({super.key});

  @override
  State<GeminiScreen> createState() => _GeminiScreenState();
}

class _GeminiScreenState extends State<GeminiScreen> {
  List<ChatMessage> messages = [];

  final Gemini gemini = Gemini.instance;

  ChatUser currentUser = ChatUser(id: "0", firstName: 'User');

  ChatUser geminiUser = ChatUser(
      id: "1",
      firstName: 'Gemini',
      profileImage:
          'https://storage.googleapis.com/gweb-uniblog-publish-prod/images/Gemini_SS.width-1300.jpg');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        backgroundColor: MyColor().primarycolor,
        title: const Text('Gemini Chat'),
      ),
      body: _buildUi(),
    );
  }

  Widget _buildUi() {
    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Image.asset('asset/Gemini png.png'),
            const SizedBox(height: 20),
            const Text(
              'Start a chat with Gemini AI',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _sendMessage(ChatMessage(
                  text: "Hello, Gemini! How can you help me today?",
                  user: currentUser,
                  createdAt: DateTime.now(),
                ));
              },
              child: const Text('Start Chat'),
            ),
          ],
        ),
      );
    }
    
    return DashChat(
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
      inputOptions: InputOptions(
        trailing: [
          IconButton(
            onPressed: _sendMediaMessage,
            icon: const Icon(Icons.image),
          )
        ],
      ),
      messageOptions: MessageOptions(
        messageTextBuilder: _buildMessageText,
      ),
    );
  }

  Widget _buildMessageText(
    ChatMessage message,
    ChatMessage? previousMessage,
    ChatMessage? nextMessage,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: MarkdownBody(
        data: message.text,
        styleSheet: MarkdownStyleSheet(
          p: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
      }
      gemini.streamGenerateContent(question, images: images).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                "",
                (previous, current) => "$previous ${current.text}",
              ) ??
              " ";
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String response = event.content?.parts?.fold(
                "",
                (previous, current) => "$previous ${current.text}",
              ) ??
              " ";
          ChatMessage message = ChatMessage(
              user: geminiUser, createdAt: DateTime.now(), text: response);
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),
          text: 'Describe this picture?',
          medias: [
            ChatMedia(url: file.path, fileName: '', type: MediaType.image)
          ]);
      _sendMessage(chatMessage);
    }
  }
}
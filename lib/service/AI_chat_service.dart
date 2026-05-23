import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../model/message_model.dart';
import '../core/api_keys.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final GenerativeModel _model;
  ChatSession? _chatSession; // ✅ Use persistent chat session

  ChatService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: ApiKeys.geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 512,
      ),
      systemInstruction: Content.system(_systemPrompt), // ✅ Proper system prompt
    );
  }

  static const String _systemPrompt = """
You are Hive, a compassionate AI wellness assistant for the SupportHive app.
Your two roles:

ROLE 1 — Stress & Mental Health Support:
- Answer questions about stress, anxiety, depression, burnout, loneliness,
  sleep problems, and emotional wellbeing with empathy and evidence-based advice.
- Keep answers calm, supportive, and concise (under 120 words).
- If the user seems in crisis, gently suggest professional help.

ROLE 2 — App Navigation Guide:
SupportHive has these features. When a user asks where something is, guide them:
  Home tab         -> Daily quote, music, podcasts, activities
  Search tab       -> Search for resources and content
  Counselling tab  -> Book a session with a counsellor (bottom nav, 2nd icon)
  Games tab        -> Mindful games for stress relief (bottom nav, 4th icon)
  AI Chat          -> This chat (drawer -> AI Chat)
  Journal/Diary    -> Home -> Quiz & Journal section -> Open Diary
  Wellness Quiz    -> Home -> Quiz & Journal section -> Take Quiz
  Wellness Status  -> Home -> Quiz & Journal section -> Check Status
  Music Player     -> Home -> Music section -> tap any track
  Podcast Player   -> Home -> Podcast section -> tap any podcast
  Profile          -> Top-right avatar icon on home screen
  Notifications    -> Top-right bell icon on home screen
  Settings         -> Drawer menu -> Settings
  Video/Call       -> Counselling screen -> Book Session

IMPORTANT:
- Always respond in plain text, no markdown symbols like ** or ##.
- Be warm and friendly. Never give medical diagnoses.
- If the question is off-topic, politely redirect back to wellness or app help.
""";

  String get _uid => _auth.currentUser?.uid ?? 'anonymous';
  CollectionReference get _chatRef =>
      _db.collection('users').doc(_uid).collection('chatHistory');

  // ✅ Build chat session from loaded history so context is preserved
  void _initChatSession(List<Message> history) {
    final geminiHistory = <Content>[];

    for (final msg in history) {
      if (msg.text == createInitialMessage().text) continue; // skip greeting
      geminiHistory.add(
        msg.isUser
            ? Content.text(msg.text)
            : Content.model([TextPart(msg.text)]),
      );
    }

    _chatSession = _model.startChat(history: geminiHistory);
    debugPrint('✅ ChatSession initialized with ${geminiHistory.length} messages');
  }

  Future<void> saveMessage(Message message) async {
    try {
      await _chatRef.doc(message.id).set(message.toMap());
    } catch (e) {
      debugPrint('❌ saveMessage error: $e'); // ✅ Now visible in debug console
    }
  }

  Future<List<Message>> loadHistory() async {
    try {
      final snap = await _chatRef
          .orderBy('timestamp', descending: false)
          .limitToLast(50)
          .get();
      final messages = snap.docs
          .map((d) => Message.fromMap(d.data() as Map<String, dynamic>))
          .toList();
      debugPrint('✅ Loaded ${messages.length} messages from Firestore');
      return messages;
    } catch (e) {
      debugPrint('❌ loadHistory error: $e'); // ✅ Now visible
      return [];
    }
  }

  Future<void> clearHistory() async {
    try {
      final snap = await _chatRef.get();
      final batch = _db.batch();
      for (final doc in snap.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      _chatSession = null; // ✅ Reset session on clear
      debugPrint('✅ Chat history cleared');
    } catch (e) {
      debugPrint('❌ clearHistory error: $e');
    }
  }

  Future<String> sendAndGetReply(
    String userMessage,
    List<Message> history,
  ) async {
    try {
      // ✅ Create session if it doesn't exist yet
      _chatSession ??= _model.startChat();

      debugPrint('📤 Sending to Gemini: $userMessage');

      final response = await _chatSession!.sendMessage(
        Content.text(userMessage),
      );

      final reply = (response.text ?? '').trim();
      debugPrint('📥 Gemini replied: $reply');

      return reply.isEmpty
          ? "I'm here for you. Tell me more 💚"
          : reply;
    } on GenerativeAIException catch (e) {
      // ✅ Catch Gemini-specific errors (rate limit, invalid key, etc.)
      debugPrint('❌ GenerativeAIException: ${e.message}');
      if (e.message.contains('API_KEY_INVALID') ||
          e.message.contains('API key not valid')) {
        return "There's a configuration issue. Please contact support. 💚";
      } else if (e.message.contains('quota') ||
          e.message.contains('RESOURCE_EXHAUSTED')) {
        return "I'm a bit busy right now. Please try again in a moment. 💚";
      }
      return "Something went wrong on my end. Please try again. 💚";
    } catch (e) {
      debugPrint('❌ sendAndGetReply error: $e'); // ✅ Always log
      return "I'm having a little trouble right now. Please try again in a moment. 💚";
    }
  }

  // ✅ Call this after loadHistory to wire up the session
  Future<List<Message>> loadHistoryAndInitSession() async {
    final history = await loadHistory();
    _initChatSession(history);
    return history;
  }

  Message createInitialMessage() {
    return Message(
      id: 'init_${DateTime.now().millisecondsSinceEpoch}',
      text:
          "Hi, I'm Hive 🐝 — your SupportHive wellness companion.\n\nI can help you with stress, anxiety, sleep, and emotional wellbeing. I can also guide you to any feature in the app.\n\nHow are you feeling today?",
      isUser: false,
      timestamp: DateTime.now(),
    );
  }
}
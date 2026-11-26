import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/localization_provider.dart';
import '../../services/http_client.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final List<String> quickOptions;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.quickOptions = const [],
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class AiFixScreen extends StatefulWidget {
  final AuthProvider auth;

  const AiFixScreen({Key? key, required this.auth}) : super(key: key);

  @override
  State<AiFixScreen> createState() => _AiFixScreenState();
}

class _AiFixScreenState extends State<AiFixScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String _sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';

  // Top horizontal suggestion prompts
  final List<String> _topSuggestions = [
    'AC gas leak & refilling',
    'Tap leaking continuously',
    'Want to book deep cleaning',
    'MCB tripping repeatedly',
    'Ceiling fan making noise',
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialGreeting();
  }

  void _loadInitialGreeting() {
    final loc = LocalizationProvider.instance;
    String greeting;
    List<String> chips;

    if (loc.code == 'OR') {
      greeting =
          'ନମସ୍କାର! ମୁଁ ପୃଥିବୀ AI — ଆପଣଙ୍କ ସରକାରୀ ସମବାୟ ରକ୍ଷଣାବେକ୍ଷଣ ଓ ନିଦାନ ଇଣ୍ଟେଲିଜେନ୍ସ। ଯେକୌଣସି ଘରୋଇ ଉପକରଣ, ପ୍ଲମ୍ବିଂ, କିମ୍ବା ବିଦ୍ୟୁତ ସମସ୍ୟା ବର୍ଣ୍ଣନା କରନ୍ତୁ, ଏବଂ ମୁଁ ସରକାରୀ ସମବାୟ ଦର ସହିତ ତୁରନ୍ତ ବୁକିଂ କରିବି।';
      chips = ['ଏସି ଗ୍ୟାସ ରିଫିଲ', 'ପାଣି ନଳ ଲିକ', 'ଘର ୱାୟାରିଂ', 'ସୋଫା ସଫେଇ'];
    } else if (loc.code == 'HI') {
      greeting =
          'नमस्ते! मैं पृथ्वी AI हूँ — आपकी आधिकारिक सहकारी रखरखाव और निदान बुद्धिमत्ता। किसी भी घरेलू उपकरण, प्लंबिंग या बिजली की समस्या बताएं, और मैं आधिकारिक दरों के साथ त्वरित बुकिंग करूँगा।';
      chips = ['एसी गैस रिफिल', 'नल लीक कर रहा है', 'हाउस रीवायरिंग', 'सोफा क्लीनिंग'];
    } else {
      greeting =
          'Namaste! I am Prithvi AI — your official Cooperative Maintenance & Diagnostic Intelligence. Describe any home appliance, plumbing, or electrical issue, and I will diagnose it with official cooperative tariffs and instant booking.';
      chips = ['AC Gas Refill', 'Tap Leaking', 'House Rewiring', 'Sofa Cleaning'];
    }

    setState(() {
      _messages.add(
        ChatMessage(
          text: greeting,
          isUser: false,
          quickOptions: chips,
        ),
      );
    });
  }

  void _resetChat() {
    setState(() {
      _sessionId = 'session_${DateTime.now().millisecondsSinceEpoch}';
      _messages.clear();
      _loadInitialGreeting();
    });
  }

  Future<void> _handleSendMessage([String? customText]) async {
    final query = (customText ?? _inputController.text).trim();
    if (query.isEmpty) return;

    if (customText == null) {
      _inputController.clear();
    }

    setState(() {
      _messages.add(ChatMessage(text: query, isUser: true));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final client = createHttpClient();
      final user = widget.auth.currentUser;
      final loc = LocalizationProvider.instance;

      // Connect to local standalone agent server or gateway
      const endpoint = 'http://127.0.0.1:4000/api/chat';

      final res = await client.post(
        endpoint,
        body: {
          'message': query,
          'sessionId': _sessionId,
          'language': loc.code,
          'userId': user?.id,
          'customerName': user?.name ?? 'Citizen Resident',
          'customerPhone': user?.phone ?? '9876543210',
          'savedHomeAddress': user?.address ?? 'Plot 42, Saheed Nagar, Bhubaneswar, Odisha 751007',
        },
      );

      final reply = res['reply']?.toString() ??
          "I have noted your issue. Verified cooperative artisans are standing by.";
      final quickOptions = (res['quickOptions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

      setState(() {
        _isLoading = false;
        _messages.add(
          ChatMessage(
            text: reply,
            isUser: false,
            quickOptions: quickOptions,
          ),
        );
      });
    } catch (e) {
      // Resilient fallback diagnosis if server is temporarily restarting
      setState(() {
        _isLoading = false;
        _messages.add(
          ChatMessage(
            text:
                "🔍 **Diagnostic In Progress**: We received your report for: \"$query\".\n\n• **Regulated Tariff**: Zero surge pricing applied.\n• **Artisan Protection**: 93% direct living wage guarantee.\n\nWould you like to confirm service for your address?",
            isUser: false,
            quickOptions: ['Confirm Booking', 'Check Tariffs', 'Cancel'],
          ),
        );
      });
    }

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

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationProvider.instance;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── TOP APP BAR ──
            _buildTopBar(loc),

            // ── TOP HORIZONTAL SUGGESTION CHIPS ──
            _buildTopSuggestionsBar(),

            const Divider(height: 1, color: Color(0xFFF1F5F9)),

            // ── CHAT MESSAGE LIST ──
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isLoading) {
                    return _buildLoadingBubble();
                  }
                  final msg = _messages[index];
                  return _buildMessageItem(msg);
                },
              ),
            ),

            // ── BOTTOM INPUT DOCK ──
            _buildBottomInputDock(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(LocalizationProvider loc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Sparkle Logo Box
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F4F1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.auto_awesome,
                color: Color(0xFF0D9488),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Title & Live Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Prithvi AI Assistant',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Live Cooperative Diagnostic Engine',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Language Selector Pill
          PopupMenuButton<AppLanguage>(
            onSelected: (AppLanguage lang) {
              loc.setLanguage(lang);
              _resetChat();
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: AppLanguage.english,
                child: Text('English (EN)'),
              ),
              const PopupMenuItem(
                value: AppLanguage.odia,
                child: Text('ଓଡ଼ିଆ (Odia)'),
              ),
              const PopupMenuItem(
                value: AppLanguage.hindi,
                child: Text('हिन्दी (Hindi)'),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.translate, size: 14, color: Color(0xFF334155)),
                  const SizedBox(width: 5),
                  Text(
                    loc.currentLanguage.label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.arrow_drop_down, size: 16, color: Color(0xFF64748B)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Restart / Refresh Button
          IconButton(
            onPressed: _resetChat,
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF334155), size: 22),
            splashRadius: 20,
            tooltip: 'Restart chat',
          ),
        ],
      ),
    );
  }

  Widget _buildTopSuggestionsBar() {
    return Container(
      height: 46,
      margin: const EdgeInsets.only(bottom: 6),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _topSuggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final prompt = _topSuggestions[index];
          return ActionChip(
            label: Text(
              prompt,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E293B),
              ),
            ),
            backgroundColor: const Color(0xFFF8FAFC),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () => _handleSendMessage(prompt),
          );
        },
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage msg) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12, left: 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A365D), // Deep Cooperative Navy
            borderRadius: BorderRadius.circular(16).copyWith(
              bottomRight: const Radius.circular(4),
            ),
          ),
          child: Text(
            msg.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      );
    }

    // AI message
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Header Tag (Sparkle icon + Prithvi AI)
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFCCFBF1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.auto_awesome,
                    size: 13,
                    color: Color(0xFF0D9488),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Prithvi AI',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Message Bubble
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              msg.text,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 13.5,
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          // Quick Action Chips underneath bubble
          if (msg.quickOptions.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: msg.quickOptions.map((chipText) {
                return OutlinedButton(
                  onPressed: () => _handleSendMessage(chipText),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0D9488),
                    side: const BorderSide(color: Color(0xFF0D9488), width: 1.2),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  child: Text(
                    chipText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Diagnosing issue with cooperative tariffs...',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInputDock() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Rounded Capsule Input Field
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                controller: _inputController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleSendMessage(),
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF0F172A),
                ),
                decoration: const InputDecoration(
                  hintText: 'Describe repair or problem (e.g. 2+2, AC l...',
                  hintStyle: TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF94A3B8),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Circular Navy Send Button
          InkWell(
            onTap: () => _handleSendMessage(),
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF1A365D), // Deep Navy
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

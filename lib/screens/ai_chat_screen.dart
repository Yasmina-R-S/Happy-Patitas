// lib/screens/ai_chat_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
//  Happy Patitas · AI Chat Screen  —  "Liquid Glass" Design
//  Modo claro y oscuro completo
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/chat_message.dart';
import '../services/ai_service.dart';

// ─── Paleta dinámica ─────────────────────────────────────────────────────────

class _P {
  final bool dark;
  const _P(this.dark);

  // Acentos que coinciden con la nav bar
  static const coral    = Color(0xFFFF6B6B);
  static const lime     = Color(0xFFC8F135);
  static const teal     = Color(0xFF00D4AA);
  static const orange   = Color(0xFFFF9B42);

  // Fondos
  Color get bg          => dark ? const Color(0xFF090912) : const Color(0xFFF2F4F8);
  Color get surface     => dark ? const Color(0xFF121220) : const Color(0xFFFFFFFF);
  Color get surfaceHigh => dark ? const Color(0xFF1C1C2E) : const Color(0xFFF7F8FC);
  Color get glass       => dark
      ? Colors.white.withOpacity(0.06)
      : Colors.white.withOpacity(0.72);
  Color get border      => dark
      ? Colors.white.withOpacity(0.08)
      : Colors.black.withOpacity(0.07);

  // Burbujas
  Color get userBg      => dark ? const Color(0xFF1A1040) : const Color(0xFFEDE7FF);
  Color get aiBg        => dark ? const Color(0xFF0F1A28) : const Color(0xFFFFFFFF);

  // Texto
  Color get textMain    => dark ? const Color(0xFFF0F0FF) : const Color(0xFF14142B);
  Color get textSub     => dark ? const Color(0xFF7B7FA6) : const Color(0xFF8E8EA9);

  Color get paw         => const Color(0xFFFF9B42);
  Color get accent      => teal;
}

// ─── Modelo interno ──────────────────────────────────────────────────────────

class _Msg {
  final ChatMessage msg;
  final DateTime ts;
  final String id;
  _Msg({required this.msg, required this.ts})
      : id = '${ts.millisecondsSinceEpoch}_${math.Random().nextInt(9999)}';
}

// ─── Screen ──────────────────────────────────────────────────────────────────

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen>
    with TickerProviderStateMixin {
  final _input  = TextEditingController();
  final _scroll = ScrollController();
  final _focus  = FocusNode();

  final List<_Msg> _msgs = [];
  bool _typing  = false;
  bool _hasText = false;
  bool _focused = false;

  // Shimmer en header
  late final AnimationController _shimmer = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 2800),
  )..repeat();

  // Pulse en botón send
  late final AnimationController _pulse = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  // Animación orb de fondo
  late final AnimationController _orb = AnimationController(
    vsync: this, duration: const Duration(seconds: 8),
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    _input.addListener(() {
      final has = _input.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
    _focus.addListener(() => setState(() => _focused = _focus.hasFocus));
    Future.delayed(const Duration(milliseconds: 700), _welcome);
  }

  void _welcome() => _addAI(
    '¡Hola! 🐾 Soy tu asistente veterinario IA. '
    'Puedo ayudarte con consejos sobre la salud, alimentación y '
    'bienestar de tu mascota. ¿En qué puedo ayudarte hoy?',
  );

  void _addAI(String text) {
    setState(() => _msgs.add(_Msg(msg: ChatMessage(text: text, isUser: false), ts: DateTime.now())));
    _scrollBottom();
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _typing) return;
    HapticFeedback.lightImpact();

    setState(() {
      _msgs.add(_Msg(msg: ChatMessage(text: text, isUser: true), ts: DateTime.now()));
      _typing = true;
    });
    _input.clear();
    _scrollBottom();

    try {
      final reply = await AIService.sendMessage(text);
      if (!mounted) return;
      setState(() {
        _typing = false;
        _msgs.add(_Msg(msg: ChatMessage(text: reply, isUser: false), ts: DateTime.now()));
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _typing = false;
        _msgs.add(_Msg(
          msg: ChatMessage(text: 'Ups, no pude conectar con la IA. Inténtalo de nuevo 🙏', isUser: false),
          ts: DateTime.now(),
        ));
      });
    }
    _scrollBottom();
  }

  void _scrollBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _input.dispose(); _scroll.dispose(); _focus.dispose();
    _shimmer.dispose(); _pulse.dispose(); _orb.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final p = _P(dark);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: p.bg,
        body: Stack(
          children: [
            // Orbs de fondo animados
            _BackgroundOrbs(orb: _orb, palette: p),
            // Contenido
            SafeArea(
              child: Column(
                children: [
                  _Header(shimmer: _shimmer, typing: _typing, palette: p),
                  Expanded(child: _buildList(p)),
                  if (_typing) _TypingRow(palette: p),
                  _InputBar(
                    ctrl: _input, focus: _focus, palette: p,
                    hasText: _hasText, typing: _typing, focused: _focused,
                    pulse: _pulse, onSend: _send,
                  ),
                  // Espacio para la nav bar flotante
                  const SizedBox(height: 88),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(_P p) {
    if (_msgs.isEmpty) return _EmptyState(palette: p);
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
      itemCount: _msgs.length,
      itemBuilder: (_, i) {
        final m = _msgs[i];
        final showDate = i == 0 || m.ts.day != _msgs[i-1].ts.day;
        return Column(
          children: [
            if (showDate) _DateDivider(ts: m.ts, palette: p),
            _BubbleRow(key: ValueKey(m.id), msg: m, palette: p),
          ],
        );
      },
    );
  }
}

// ─── Background Orbs ─────────────────────────────────────────────────────────

class _BackgroundOrbs extends StatelessWidget {
  final AnimationController orb;
  final _P palette;
  const _BackgroundOrbs({required this.orb, required this.palette});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: orb,
      builder: (_, __) {
        final t = orb.value;
        return Stack(
          children: [
            Positioned(
              top: -60 + 30 * t,
              right: -40 + 20 * math.sin(t * math.pi),
              child: _Orb(size: 220, color: _P.coral.withOpacity(palette.dark ? 0.12 : 0.07)),
            ),
            Positioned(
              bottom: 100 + 40 * t,
              left: -60,
              child: _Orb(size: 180, color: _P.teal.withOpacity(palette.dark ? 0.10 : 0.06)),
            ),
            Positioned(
              top: 300 + 50 * math.sin(t * math.pi * 2),
              right: 20,
              child: _Orb(size: 100, color: _P.lime.withOpacity(palette.dark ? 0.08 : 0.05)),
            ),
          ],
        );
      },
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
      child: const SizedBox.expand(),
    ),
  );
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final AnimationController shimmer;
  final bool typing;
  final _P palette;
  const _Header({required this.shimmer, required this.typing, required this.palette});

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: p.glass,
            border: Border(bottom: BorderSide(color: p.border, width: 1)),
          ),
          child: Row(
            children: [
              // Avatar IA con gradiente animado
              AnimatedBuilder(
                animation: shimmer,
                builder: (_, __) => Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      transform: GradientRotation(shimmer.value * math.pi * 2),
                      colors: const [_P.coral, _P.teal, _P.lime, _P.coral],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _P.teal.withOpacity(0.35),
                        blurRadius: 16,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.5),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: p.dark ? const Color(0xFF0D0D1A) : Colors.white,
                      ),
                      child: Icon(Icons.pets_rounded, color: p.paw, size: 22),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Asistente Veterinario',
                      style: GoogleFonts.sora(
                        color: p.textMain, fontSize: 15, fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 6, height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: typing ? p.paw : _P.teal,
                            boxShadow: [
                              BoxShadow(
                                color: (typing ? p.paw : _P.teal).withOpacity(0.7),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          typing ? 'Escribiendo…' : 'En línea',
                          style: GoogleFonts.sora(
                            color: p.textSub, fontSize: 11, fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              _GlassButton(
                icon: Icons.more_horiz_rounded,
                palette: p,
                onTap: () => _showInfo(context, p),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfo(BuildContext context, _P p) {
    showModalBottomSheet(
      context: context,
      backgroundColor: p.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _InfoSheet(palette: p),
    );
  }
}

// ─── Info sheet ───────────────────────────────────────────────────────────────

class _InfoSheet extends StatelessWidget {
  final _P palette;
  const _InfoSheet({required this.palette});

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 36, height: 3,
            decoration: BoxDecoration(color: p.border, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 24),
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [_P.teal, _P.coral]),
            ),
            child: const Icon(Icons.pets_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 16),
          Text('Asistente Veterinario IA',
            style: GoogleFonts.sora(color: p.textMain, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Powered by OpenRouter · LLaMA 3',
            style: GoogleFonts.sora(color: p.textSub, fontSize: 13)),
          const SizedBox(height: 16),
          Text(
            'Ofrece orientación general sobre mascotas. Para diagnósticos, consulta siempre a un veterinario.',
            textAlign: TextAlign.center,
            style: GoogleFonts.sora(color: p.textSub, fontSize: 13, height: 1.6),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _P.teal,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
              child: Text('Cerrar', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final _P palette;
  const _EmptyState({required this.palette});

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 90, height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [_P.teal.withOpacity(0.2), _P.coral.withOpacity(0.15)],
            ),
            border: Border.all(color: _P.teal.withOpacity(0.3), width: 1.5),
          ),
          child: Icon(Icons.chat_bubble_outline_rounded, color: p.paw, size: 38),
        ),
        const SizedBox(height: 18),
        Text('Pregunta lo que quieras',
          style: GoogleFonts.sora(color: p.textSub, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Text('Estoy aquí para ayudarte 🐾',
          style: GoogleFonts.sora(color: p.textSub.withOpacity(0.6), fontSize: 12)),
      ]),
    );
  }
}

// ─── Date divider ─────────────────────────────────────────────────────────────

class _DateDivider extends StatelessWidget {
  final DateTime ts;
  final _P palette;
  const _DateDivider({required this.ts, required this.palette});

  String _label() {
    final now = DateTime.now();
    if (ts.day == now.day) return 'Hoy';
    final y = now.subtract(const Duration(days: 1));
    if (ts.day == y.day && ts.month == y.month) return 'Ayer';
    return '${ts.day}/${ts.month}/${ts.year}';
  }

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(children: [
        Expanded(child: Divider(color: p.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: p.surfaceHigh,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: p.border),
            ),
            child: Text(_label(),
              style: GoogleFonts.sora(color: p.textSub, fontSize: 10.5, fontWeight: FontWeight.w600)),
          ),
        ),
        Expanded(child: Divider(color: p.border)),
      ]),
    );
  }
}

// ─── Typing indicator ─────────────────────────────────────────────────────────

class _TypingRow extends StatelessWidget {
  final _P palette;
  const _TypingRow({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, bottom: 6, top: 2),
      child: Row(
        children: [
          _MiniAvatar(palette: palette),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: palette.glass,
                  border: Border.all(color: palette.border),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: _TypingDots(palette: palette),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bubble row ───────────────────────────────────────────────────────────────

class _BubbleRow extends StatefulWidget {
  final _Msg msg;
  final _P palette;
  const _BubbleRow({super.key, required this.msg, required this.palette});

  @override
  State<_BubbleRow> createState() => _BubbleRowState();
}

class _BubbleRowState extends State<_BubbleRow> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
  late final Animation<double> _opacity = CurvedAnimation(parent: _c, curve: Curves.easeOut);
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: Offset(widget.msg.msg.isUser ? 0.2 : -0.2, 0.05),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));

  @override void initState() { super.initState(); _c.forward(); }
  @override void dispose()   { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.msg.msg.isUser;
    final p = widget.palette;

    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[_MiniAvatar(palette: p), const SizedBox(width: 8)],
              Flexible(
                child: Column(
                  crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    _Bubble(msg: widget.msg, palette: p),
                    const SizedBox(height: 4),
                    _Ts(ts: widget.msg.ts, isUser: isUser, palette: p),
                  ],
                ),
              ),
              if (isUser) ...[const SizedBox(width: 8), _UserAv(palette: p)],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Bubble ───────────────────────────────────────────────────────────────────

class _Bubble extends StatelessWidget {
  final _Msg msg;
  final _P palette;
  const _Bubble({required this.msg, required this.palette});

  @override
  Widget build(BuildContext context) {
    final isUser = msg.msg.isUser;
    final p = palette;

    final br = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          );

    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: msg.msg.text));
        HapticFeedback.mediumImpact();
      },
      child: ClipRRect(
        borderRadius: br,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.74),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: br,
              gradient: isUser
                  ? LinearGradient(
                      colors: p.dark
                          ? [const Color(0xFF6B2EFF).withOpacity(0.7), const Color(0xFF00D4AA).withOpacity(0.5)]
                          : [const Color(0xFF7C3AED).withOpacity(0.85), const Color(0xFF00B894).withOpacity(0.75)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isUser ? null : p.aiBg,
              border: Border.all(
                color: isUser
                    ? _P.teal.withOpacity(0.3)
                    : p.border,
                width: 1,
              ),
              boxShadow: [
                if (isUser) BoxShadow(
                  color: _P.teal.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(p.dark ? 0.3 : 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SelectableText(
              msg.msg.text,
              style: GoogleFonts.sora(
                color: isUser ? Colors.white : p.textMain,
                fontSize: 14,
                height: 1.55,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Timestamp ────────────────────────────────────────────────────────────────

class _Ts extends StatelessWidget {
  final DateTime ts;
  final bool isUser;
  final _P palette;
  const _Ts({required this.ts, required this.isUser, required this.palette});

  @override
  Widget build(BuildContext context) {
    final h = ts.hour.toString().padLeft(2, '0');
    final m = ts.minute.toString().padLeft(2, '0');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$h:$m', style: GoogleFonts.sora(color: palette.textSub, fontSize: 10)),
        if (isUser) ...[
          const SizedBox(width: 4),
          Icon(Icons.done_all_rounded, color: _P.teal, size: 12),
        ],
      ],
    );
  }
}

// ─── Avatars ──────────────────────────────────────────────────────────────────

class _MiniAvatar extends StatelessWidget {
  final _P palette;
  const _MiniAvatar({required this.palette});

  @override
  Widget build(BuildContext context) => Container(
    width: 32, height: 32,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(colors: [_P.teal, _P.coral]),
    ),
    child: const Icon(Icons.pets_rounded, color: Colors.white, size: 16),
  );
}

class _UserAv extends StatelessWidget {
  final _P palette;
  const _UserAv({required this.palette});

  @override
  Widget build(BuildContext context) => Container(
    width: 32, height: 32,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: const LinearGradient(
        colors: [Color(0xFF6B2EFF), Color(0xFF00D4AA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: palette.border.withOpacity(0.5)),
    ),
    child: const Icon(Icons.person_rounded, color: Colors.white, size: 17),
  );
}

// ─── Typing dots ──────────────────────────────────────────────────────────────

class _TypingDots extends StatefulWidget {
  final _P palette;
  const _TypingDots({required this.palette});
  @override State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 1100),
  )..repeat();
  @override void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42, height: 14,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (i) => AnimatedBuilder(
          animation: _c,
          builder: (_, __) {
            final t = (_c.value - i * 0.18).clamp(0.0, 1.0);
            final s = 0.6 + 0.7 * math.sin(t * math.pi);
            return Transform.scale(
              scale: s,
              child: Container(
                width: 7, height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _P.teal.withOpacity(0.5 + 0.5 * math.sin(t * math.pi)),
                ),
              ),
            );
          },
        )),
      ),
    );
  }
}

// ─── Input bar ────────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final TextEditingController ctrl;
  final FocusNode focus;
  final _P palette;
  final bool hasText, typing, focused;
  final AnimationController pulse;
  final VoidCallback onSend;

  const _InputBar({
    required this.ctrl, required this.focus, required this.palette,
    required this.hasText, required this.typing, required this.focused,
    required this.pulse, required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            color: p.glass,
            border: Border(top: BorderSide(
              color: focused ? _P.teal.withOpacity(0.4) : p.border,
              width: 1,
            )),
          ),
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Campo de texto
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 130),
                  decoration: BoxDecoration(
                    color: p.surfaceHigh,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: focused ? _P.teal.withOpacity(0.45) : p.border,
                      width: 1.5,
                    ),
                    boxShadow: focused ? [
                      BoxShadow(color: _P.teal.withOpacity(0.12), blurRadius: 16),
                    ] : null,
                  ),
                  child: TextField(
                    controller: ctrl,
                    focusNode: focus,
                    maxLines: null, minLines: 1,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    style: GoogleFonts.sora(
                      color: p.textMain, fontSize: 14, height: 1.45,
                    ),
                    cursorColor: _P.teal,
                    decoration: InputDecoration(
                      hintText: '¿Cómo está tu mascota hoy?',
                      hintStyle: GoogleFonts.sora(color: p.textSub, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 14, right: 4),
                        child: Icon(Icons.pets_rounded, color: p.paw, size: 18),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 42, minHeight: 0),
                    ),
                    onSubmitted: (_) => onSend(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Send button
              _SendBtn(hasText: hasText, typing: typing, pulse: pulse, onSend: onSend, palette: p),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Send button ──────────────────────────────────────────────────────────────

class _SendBtn extends StatelessWidget {
  final bool hasText, typing;
  final AnimationController pulse;
  final VoidCallback onSend;
  final _P palette;
  const _SendBtn({required this.hasText, required this.typing, required this.pulse, required this.onSend, required this.palette});

  @override
  Widget build(BuildContext context) {
    final active = hasText && !typing;
    return AnimatedBuilder(
      animation: pulse,
      builder: (_, __) => GestureDetector(
        onTap: active ? onSend : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 50, height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: active
                ? const LinearGradient(
                    colors: [_P.teal, Color(0xFF00A88A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: active ? null : palette.surfaceHigh,
            border: Border.all(
              color: active ? _P.teal.withOpacity(0.5) : palette.border,
              width: 1.5,
            ),
            boxShadow: active ? [
              BoxShadow(
                color: _P.teal.withOpacity(0.3 + 0.2 * pulse.value),
                blurRadius: 20,
                spreadRadius: -2,
              ),
            ] : null,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: typing
                ? SizedBox(
                    key: const ValueKey('l'),
                    width: 20, height: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: CircularProgressIndicator(strokeWidth: 2, color: _P.teal),
                    ),
                  )
                : Icon(
                    key: const ValueKey('s'),
                    Icons.send_rounded,
                    color: active ? Colors.black : palette.textSub,
                    size: 20,
                  ),
          ),
        ),
      ),
    );
  }
}

// ─── Glass button genérico ────────────────────────────────────────────────────

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final _P palette;
  const _GlassButton({required this.icon, required this.onTap, required this.palette});

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      splashColor: _P.teal.withOpacity(0.1),
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: palette.glass,
          border: Border.all(color: palette.border, width: 1),
        ),
        child: Icon(icon, color: palette.textSub, size: 20),
      ),
    ),
  );
}

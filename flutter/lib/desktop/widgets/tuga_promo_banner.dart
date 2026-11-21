import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class _PromoItem {
  final IconData icon;
  final String text;
  const _PromoItem(this.icon, this.text);
}

/// TUGA XXTURNER promotional banner at the top of the desktop home page.
/// Rotates through the messages; a tap opens the TUGA Telegram channel.
class TugaPromoBanner extends StatefulWidget {
  const TugaPromoBanner({Key? key}) : super(key: key);

  @override
  State<TugaPromoBanner> createState() => _TugaPromoBannerState();
}

class _TugaPromoBannerState extends State<TugaPromoBanner> {
  static const _url = 'https://t.me/streamingtv2020';
  static const _gold = Color(0xFFD4AF37);
  static const _messages = <_PromoItem>[
    _PromoItem(Icons.live_tv_rounded, 'Fonte Local de Canais Portugueses'),
    _PromoItem(Icons.movie_rounded, 'Fonte de VOD Portugueses'),
    _PromoItem(Icons.shield_rounded, 'DRM'),
    _PromoItem(Icons.sync_rounded, 'Sincronizador de Conteúdo Automático'),
    _PromoItem(Icons.star_rounded, 'Pack 500 Canais Adultos'),
  ];

  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % _messages.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = _messages[_index];
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(_url)),
        child: Container(
          height: 56,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF06382A), Color(0xFF101418), Color(0xFF4A0D0D)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            border: Border(bottom: BorderSide(color: _gold, width: 1.5)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _gold, width: 1.4),
                  color: Colors.white.withOpacity(0.08),
                ),
                child: Icon(item.icon, color: const Color(0xFFF5D67B), size: 19),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.35),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: Align(
                    key: ValueKey(_index),
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(
                      item.text,
                      maxLines: 1,
                      minFontSize: 11,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(_messages.length, (i) {
                  final active = i == _index;
                  return Container(
                    width: active ? 16 : 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color:
                          active ? _gold : Colors.white.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF229ED9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.send_rounded, color: Colors.white, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'Telegram',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

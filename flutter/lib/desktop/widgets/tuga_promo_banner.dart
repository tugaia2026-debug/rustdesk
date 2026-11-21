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
/// Shows an IPTV-themed photo background, rotates through the messages,
/// and opens the TUGA Telegram channel on tap.
class TugaPromoBanner extends StatefulWidget {
  final bool english;
  const TugaPromoBanner({Key? key, this.english = false}) : super(key: key);

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
    _PromoItem(Icons.sync_rounded,
        'Sincronizador de Conteúdo Automático — Xtream Masters · XUI One · XUI 1.8 · Midnight Streamer'),
    _PromoItem(Icons.star_rounded, 'Pack 500 Canais Adultos'),
    _PromoItem(Icons.storage_rounded,
        'Venda de Servidores Offshore — 5GB 350€ · 10GB 450€'),
    _PromoItem(Icons.tv_rounded, 'Aplicação Smart TV Samsung & LG — 150€ cada DNS'),
    _PromoItem(Icons.repeat_rounded, 'Restream — 2€ abaixo de 2 CNX · 1,50€ acima'),
  ];
  static const _messagesEn = <_PromoItem>[
    _PromoItem(Icons.live_tv_rounded, 'Local Source of Portuguese Channels'),
    _PromoItem(Icons.movie_rounded, 'Portuguese VOD Source'),
    _PromoItem(Icons.shield_rounded, 'DRM'),
    _PromoItem(Icons.sync_rounded,
        'Automatic Content Synchronizer — Xtream Masters · XUI One · XUI 1.8 · Midnight Streamer'),
    _PromoItem(Icons.star_rounded, '500 Adult Channels Pack'),
    _PromoItem(Icons.storage_rounded,
        'Offshore Servers for Sale — 5GB €350 · 10GB €450'),
    _PromoItem(Icons.tv_rounded, 'Smart TV App Samsung & LG — €150 per DNS'),
    _PromoItem(Icons.repeat_rounded, 'Restream — €2 under 2 CNX · €1.50 above'),
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
    final messages = widget.english ? _messagesEn : _messages;
    final item = messages[_index];
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(_url)),
        child: Container(
          height: 76,
          width: double.infinity,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: _gold, width: 2)),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/tuga_banner_bg.jpg',
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.80),
                      Colors.black.withOpacity(0.45),
                      Colors.black.withOpacity(0.68),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _gold, width: 1.6),
                        color: Colors.black.withOpacity(0.35),
                      ),
                      child:
                          Icon(item.icon, color: const Color(0xFFF5D67B), size: 25),
                    ),
                    const SizedBox(width: 14),
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
                            minFontSize: 12,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 6,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(messages.length, (i) {
                        final active = i == _index;
                        return Container(
                          width: active ? 18 : 7,
                          height: 7,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: active
                                ? _gold
                                : Colors.white.withOpacity(0.40),
                            borderRadius: BorderRadius.circular(3.5),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF229ED9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.send_rounded,
                              color: Colors.white, size: 16),
                          SizedBox(width: 7),
                          Text(
                            'Telegram',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
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

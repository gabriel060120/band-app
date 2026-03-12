import 'package:band_app/ui/lyrics/cubits/lyrics_cubit.dart';
import 'package:band_app/ui/lyrics/cubits/lyrics_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import 'lyrics_widget.dart';

/// Tela de visualização de letra (UI mockup semelhante à imagem enviada).
/// Trabalha apenas neste arquivo e utiliza o tema do app (cores e tipografia).
class LyricsScreen extends StatefulWidget {
  const LyricsScreen({super.key});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  double _speed = 1.0;
  final ScrollController _scrollController = ScrollController();
  bool _showControls = true;
  ScrollDirection? _lastDir;
  bool _isPlaying = false;
  late final Ticker _ticker;
  Duration? _lastTickElapsed;
  static const double _baseScrollSpeed = 10.0;

  // Detect lines that look like chord lines (simple heuristic)
  // bool _isChordLine(String line) {
  //   final trimmed = line.trim();
  //   if (trimmed.isEmpty) return false;
  //   // chords usually have A-G letters and characters like m, 7, #, b, sus, add
  //   final chordToken = RegExp(r"^[A-G](#|b)?[a-zA-Z0-9()\/\-]*");
  //   final tokens = trimmed.split(RegExp(r"\s+"));
  //   // if all tokens match chordToken and at least one token, it's a chord line
  //   return tokens.isNotEmpty && tokens.every((t) => chordToken.hasMatch(t));
  // }

  // List<String> _paragraphsFromContent(String content) {
  //   // Split paragraphs by two newlines (preserves chord lines inside paragraphs)
  //   return content.split(RegExp(r"\n\s*\n"));
  // }

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_onTick);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (!_isPlaying) return;
    if (_lastTickElapsed != null) {
      final delta = elapsed - _lastTickElapsed!;
      final dt = delta.inMilliseconds / 500.0;
      final pixels = _baseScrollSpeed * _speed * dt;
      final maxScroll = _scrollController.position.maxScrollExtent;
      double newOffset = _scrollController.offset + pixels;
      if (newOffset > maxScroll) {
        newOffset = maxScroll;
        _stopScroll();
        return;
      }
      _scrollController.jumpTo(newOffset);
    }
    _lastTickElapsed = elapsed;
  }

  void _startScroll() {
    if (_isPlaying) return;
    _lastTickElapsed = null;
    setState(() {
      _isPlaying = true;
    });
    _ticker.start();
  }

  void _stopScroll() {
    if (!_isPlaying) return;
    _lastTickElapsed = null;
    setState(() {
      _isPlaying = false;
    });
    _ticker.stop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<LyricsCubit>();

    return SafeArea(
      top: false,
      child: BlocBuilder<LyricsCubit, LyricsState>(
        bloc: cubit,
        builder: (context, state) {
          var currentLyrics = state.lyrics[state.index];
          return Scaffold(
            body: NotificationListener<UserScrollNotification>(
              onNotification: (n) {
                final dir = n.direction;
                if (dir == ScrollDirection.idle) return false;
                if (dir != _lastDir) {
                  _lastDir = dir;
                  if (dir == ScrollDirection.reverse && _showControls) {
                    setState(() => _showControls = false);
                  } else if (dir == ScrollDirection.forward && !_showControls) {
                    setState(() => _showControls = true);
                  }
                }
                return false;
              },
              child: Stack(
                children: [
                  NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverAppBar(
                        floating: true,
                        snap: true,
                        pinned: false,
                        title: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currentLyrics.title,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              currentLyrics.artist,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color
                                    ?.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                        centerTitle: true,
                        actions: [
                          IconButton(
                            onPressed: () {
                              SharePlus.instance.share(
                                ShareParams(
                                  text:
                                      '${currentLyrics.title} - ${currentLyrics.artist}\n\n${currentLyrics.content}',
                                ),
                              );
                            },
                            icon: const Icon(Icons.share_rounded),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.settings),
                          ),
                          const SizedBox(width: 6),
                        ],
                      ),
                    ],
                    body: SingleChildScrollView(
                      controller: _scrollController,
                      child: IndexedStack(
                        index: state.index,
                        children: state.lyrics
                            .map((l) => LyricsWidget(lyrics: l))
                            .toList(),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedSlide(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      offset: _showControls ? Offset.zero : const Offset(0, 1),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 180),
                        opacity: _showControls ? 1 : 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            border: Border(
                              top: BorderSide(
                                color: theme.dividerColor.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                            ),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: SliderTheme(
                                            data: SliderTheme.of(
                                              context,
                                            ).copyWith(trackHeight: 4),
                                            child: Slider(
                                              value: _speed,
                                              min: 0.25,
                                              max: 2.0,
                                              divisions: 7,
                                              onChanged: (v) {
                                                setState(() => _speed = v);
                                                if (_isPlaying) {
                                                  // Atualiza a velocidade em tempo real
                                                  _ticker.stop();
                                                  _ticker.start();
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            if (_isPlaying) {
                                              _stopScroll();
                                            } else {
                                              _startScroll();
                                            }
                                          },
                                          icon: Icon(
                                            _isPlaying
                                                ? Icons.pause_rounded
                                                : Icons.play_arrow_rounded,
                                            size: 22,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.arrow_back),
                                          onPressed: state.index > 0
                                              ? () {
                                                  cubit.previousLyrics();
                                                  _scrollController.jumpTo(0);
                                                  _stopScroll();
                                                }
                                              : null,
                                        ),
                                        Text(
                                          '${state.index + 1} / ${state.lyrics.length}',
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.arrow_forward),
                                          onPressed:
                                              state.index <
                                                  state.lyrics.length - 1
                                              ? () {
                                                  cubit.nextLyrics();
                                                  _scrollController.jumpTo(0);
                                                  _stopScroll();
                                                }
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ...existing code...
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget _buildParagraph(String paragraph, ThemeData theme, int index) {
  //   // A paragraph might contain chord lines and lyric lines separated by single newlines
  //   final lines = paragraph.split('\n');

  //   // Build the main content area and a right-side column for up/down small controls
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       // Expanded lyrics area
  //       Expanded(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: lines.map<Widget>((line) {
  //             final isChord = _isChordLine(line);
  //             final isSpecial = line.trim().toUpperCase().contains('[REFR');
  //             if (isSpecial) {
  //               return Container(
  //                 margin: const EdgeInsets.symmetric(vertical: 8),
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 10,
  //                   vertical: 6,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color: theme.colorScheme.primary.withValues(alpha: 0.06),
  //                   borderRadius: BorderRadius.circular(6),
  //                   border: Border.all(
  //                     color: theme.colorScheme.primary.withValues(alpha: 0.15),
  //                   ),
  //                 ),
  //                 child: Text(
  //                   line.trim(),
  //                   style: theme.textTheme.bodySmall?.copyWith(
  //                     fontWeight: FontWeight.bold,
  //                     color: theme.colorScheme.primary,
  //                   ),
  //                 ),
  //               );
  //             }

  //             if (isChord) {
  //               return Padding(
  //                 padding: const EdgeInsets.only(top: 6.0, bottom: 4.0),
  //                 child: Text(
  //                   line.trim(),
  //                   style: theme.textTheme.bodySmall?.copyWith(
  //                     color: Colors.amber.shade700,
  //                     fontWeight: FontWeight.w700,
  //                   ),
  //                 ),
  //               );
  //             }

  //             return Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 6.0),
  //               child: Text(line, style: theme.textTheme.bodyLarge),
  //             );
  //           }).toList(),
  //         ),
  //       ),

  //       const SizedBox(width: 12),

  //       // Right-side small controls (up/down icons) grouped vertically
  //       Column(
  //         children: [
  //           InkWell(
  //             onTap: () {},
  //             borderRadius: BorderRadius.circular(6),
  //             child: Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
  //               decoration: BoxDecoration(
  //                 color: theme.cardColor.withValues(alpha: 0.04),
  //                 borderRadius: BorderRadius.circular(6),
  //               ),
  //               child: const Icon(Icons.keyboard_arrow_up, size: 18),
  //             ),
  //           ),
  //           const SizedBox(height: 8),
  //           Container(
  //             width: 28,
  //             height: 28,
  //             decoration: BoxDecoration(
  //               color: theme.dividerColor.withValues(alpha: 0.05),
  //               borderRadius: BorderRadius.circular(6),
  //             ),
  //             child: const Icon(Icons.swap_vert, size: 16),
  //           ),
  //           const SizedBox(height: 8),
  //           InkWell(
  //             onTap: () {},
  //             borderRadius: BorderRadius.circular(6),
  //             child: Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
  //               decoration: BoxDecoration(
  //                 color: theme.cardColor.withValues(alpha: 0.04),
  //                 borderRadius: BorderRadius.circular(6),
  //               ),
  //               child: const Icon(Icons.keyboard_arrow_down, size: 18),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }
}

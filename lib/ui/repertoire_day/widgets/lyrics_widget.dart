import 'package:band_app/ui/lyrics/cubits/lyrics_cubit.dart';
import 'package:band_app/ui/lyrics/cubits/lyrics_state.dart';
import 'package:band_app/ui/lyrics/widgets/lyrics_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            appBar: AppBar(
              // leading: IconButton(
              //   icon: const Icon(Icons.chevron_left_outlined),
              //   onPressed: () => Navigator.maybePop(context),
              // ),
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
                      color: theme.textTheme.bodySmall?.color?.withValues(
                        alpha: 0.8,
                      ),
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
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
                const SizedBox(width: 6),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: IndexedStack(
                      index: state.index,
                      children: state.lyrics
                          .map((l) => LyricsWidget(lyrics: l))
                          .toList(),
                    ),
                  ),
                ),

                // Bottom controls (tempo slider + central action)
                Material(
                  color: theme.colorScheme.surfaceContainerHighest,
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    child: Column(
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
                                  onChanged: (v) => setState(() => _speed = v),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.play_arrow_rounded, size: 22),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: state.index > 0
                                  ? () {
                                      cubit.previousLyrics();
                                    }
                                  : null,
                            ),
                            Text('${state.index + 1} / ${state.lyrics.length}'),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: state.index < state.lyrics.length - 1
                                  ? () {
                                      cubit.nextLyrics();
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

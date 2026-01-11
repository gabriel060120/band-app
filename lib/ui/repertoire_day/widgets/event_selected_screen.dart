import 'package:band_app/ui/repertoire_day/cubits/event_selected_cubit.dart';
import 'package:band_app/ui/repertoire_day/cubits/event_selected_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EventSelectedScreen extends StatefulWidget {
  const EventSelectedScreen({super.key});

  @override
  State<EventSelectedScreen> createState() => _EventSelectedScreenState();
}

class _EventSelectedScreenState extends State<EventSelectedScreen> {
  late final EventSelectedCubit cubit;

  @override
  void initState() {
    cubit = context.read<EventSelectedCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Evento'), elevation: 0),
      body: BlocBuilder<EventSelectedCubit, EventSelectedState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is EventSelectedLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EventSelectedErrorState) {
            return Center(child: Text(state.errorMessage));
          } else if (state is EventSelectedLoadedState) {
            return SafeArea(
              top: false,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.eventData.eventDay.title,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Igreja',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.purpleAccent,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: [
                              _InfoChip(
                                icon: Icons.calendar_today,
                                label: DateFormat(
                                  'd MMM',
                                  'pt_BR',
                                ).format(state.eventData.eventDay.date),
                              ),
                              _InfoChip(
                                icon: Icons.access_time,
                                label: DateFormat(
                                  'HH:mm',
                                ).format(state.eventData.eventDay.date),
                              ),
                              // _InfoChip(icon: Icons.place, label: 'Parque das Nações'),
                            ],
                          ),

                          const SizedBox(height: 22),

                          if (state.eventData.eventDay.observations.isNotEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.brown.shade700.withValues(
                                  alpha: 0.9,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.orange.shade700.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.orange.shade700,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Atenção:',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          state.eventData.eventDay.observations,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: Colors.white.withValues(
                                                  alpha: 0.95,
                                                ),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 24),

                          // Setlist header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Repertório',
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    color: Colors.grey.shade300,
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800.withValues(
                                    alpha: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(
                                  '${state.eventData.musics.length} MÚSICAS',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: Colors.grey[200],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Setlist items
                          Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            color: Colors.transparent,
                            elevation: 0,
                            child: Column(
                              children: List.generate(
                                state.eventData.musics.length,
                                (index) {
                                  final item = state.eventData.musics[index];
                                  return Column(
                                    children: [
                                      ListTile(
                                        dense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                        leading: Text(
                                          '${index + 1}',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                color: Colors.grey[300],
                                                fontSize: 18,
                                              ),
                                        ),
                                        title: RichText(
                                          text: TextSpan(
                                            text: '${item.name} ',
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                            children: [
                                              TextSpan(
                                                text: '- ${item.artist}',
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: Colors.grey[400],
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        trailing: Text(
                                          '0:00',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: Colors.grey[200],
                                              ),
                                        ),
                                      ),
                                      if (index <
                                          state.eventData.musics.length - 1)
                                        Divider(
                                          color: Colors.grey.withValues(
                                            alpha: 0.25,
                                          ),
                                          height: 1,
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                  if (cubit.hasCiphers || cubit.hasLyrics)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade800.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          if (cubit.hasLyrics)
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  final lyrics = cubit.selectLyrics();
                                  context.pushNamed(
                                    'lyrics_list',
                                    extra: lyrics,
                                  );
                                },
                                icon: const Icon(
                                  Icons.description_outlined,
                                  color: Colors.blueAccent,
                                  size: 22,
                                ),
                                label: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14.0),
                                  child: Text(
                                    'Letras',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade800
                                      .withValues(alpha: 0.4),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          if (cubit.hasCiphers) ...[
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(28),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.purple,
                                        Colors.deepPurpleAccent,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.deepPurpleAccent
                                            .withValues(alpha: 0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.music_note,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Cifras',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade800.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.grey[200]),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[200]),
          ),
        ],
      ),
    );
  }
}

import 'package:band_app/domain/models/repertoire_day/repertoire_day.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimelineRepertoireWidget extends StatelessWidget {
  const TimelineRepertoireWidget({
    super.key,
    required this.repertoireDays,
    required this.onTapRepertoire,
  });

  final List<RepertoireDay> repertoireDays;
  final void Function(RepertoireDay) onTapRepertoire;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: repertoireDays.length,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      itemBuilder: (context, index) {
        final repertoireDay = repertoireDays[index];
        final isLast = index == repertoireDays.length - 1;

        return IntrinsicHeight(
          child: Row(
            children: [
              // Linha vertical da timeline
              SizedBox(
                width: 24,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Icon(Icons.event_note),
                    ),
                    Expanded(child: VerticalDivider(width: 2)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Conteúdo do card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: _TimelineCard(
                    repertoireDay: repertoireDay,
                    onTap: () => onTapRepertoire(repertoireDay),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.repertoireDay, required this.onTap});

  final RepertoireDay repertoireDay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = DateFormat('dd/MM/yyyy').format(repertoireDay.date);

    return Container(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 8),
                  Text(date, style: theme.textTheme.bodyMedium),
                ],
              ),
              if (repertoireDay.title.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  repertoireDay.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              // Row(
              //   children: [
              //     _CountBadge(
              //       icon: Icons.music_note,
              //       count: repertoireDay.lyrics.length,
              //       label: 'Letras',
              //     ),
              //     const SizedBox(width: 16),
              //     _CountBadge(
              //       icon: Icons.queue_music,
              //       count: repertoireDay.ciphers.length,
              //       label: 'Cifras',
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({
    required this.icon,
    required this.count,
    required this.label,
  });

  final IconData icon;
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 4),
        Text(
          '$count $label',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

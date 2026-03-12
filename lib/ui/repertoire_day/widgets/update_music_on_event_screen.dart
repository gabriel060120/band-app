import 'package:band_app/domain/models/repertoire_day/music.dart';
import 'package:band_app/ui/repertoire_day/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubits/cubits.dart';

class UpdateMusicOnEventScreen extends StatefulWidget {
  const UpdateMusicOnEventScreen({
    super.key,
    required this.initialSelectedMusics,
    required this.eventId,
  });
  final List<Music> initialSelectedMusics;
  final String eventId;

  @override
  State<UpdateMusicOnEventScreen> createState() =>
      _UpdateMusicOnEventScreenState();
}

class _UpdateMusicOnEventScreenState extends State<UpdateMusicOnEventScreen> {
  late final UpdateMusicOnEventCubit cubit;

  @override
  void initState() {
    cubit = context.read<UpdateMusicOnEventCubit>();
    cubit.getAllMusics(widget.initialSelectedMusics);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateMusicOnEventCubit, UpdateMusicOnEventState>(
      listener: (context, state) {
        if (state is UpdateMusicOnEventUpdated) {
          context.pop(true);
        } else if (state is UpdateMusicOnEventUpdateError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(title: const Text('Atualizar Músicas')),
          body: BlocBuilder(
            bloc: cubit,
            builder: (context, state) {
              if (state is UpdateMusicOnEventLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UpdateMusicOnEventError) {
                return Center(child: Text(state.message));
              }
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...cubit.allMusics.map(
                            (music) => MusicCardWidget(
                              title: music.musicData.name,
                              artist: music.musicData.artist,
                              isChecked: music.isSelected,
                              onChanged: (isSelected) {
                                cubit.changeMusicStatus(music.musicData);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.shade800.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: state is UpdateMusicOnEventUpdating
                          ? null
                          : () {
                              cubit.updateMusicToEvent(eventId: widget.eventId);
                            },
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all<Size>(
                          Size(double.infinity, 50),
                        ),
                      ),
                      child: state is UpdateMusicOnEventUpdating
                          ? CircularProgressIndicator()
                          : Text('Salvar', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

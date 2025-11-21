import 'package:band_app/ui/repertoire_day/cubits/repertoire_day_cubit.dart';
import 'package:band_app/ui/repertoire_day/cubits/repertoire_day_state.dart';
import 'package:band_app/ui/repertoire_day/widgets/select_repertoire_type_widget.dart';
import 'package:band_app/ui/repertoire_day/widgets/timeline_repertoire_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RepertoireDayScreen extends StatefulWidget {
  const RepertoireDayScreen({super.key});

  @override
  State<RepertoireDayScreen> createState() => _RepertoireDayScreenState();
}

class _RepertoireDayScreenState extends State<RepertoireDayScreen> {
  late final RepertoireDayCubit cubit;

  @override
  void initState() {
    cubit = context.read<RepertoireDayCubit>();
    super.initState();
    cubit.fetchRepertoireDays();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eventos')),
      body: BlocBuilder(
        bloc: cubit,
        builder: (context, state) {
          if (state is RepertoireDayLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RepertoireDayError) {
            return Center(child: Text(state.message));
          } else if (state is RepertoireDayListState) {
            if (state.repertoireDays.isEmpty) {
              return const Center(child: Text('Nenhum evento encontrado'));
            }
            return TimelineRepertoireWidget(
              repertoireDays: state.repertoireDays,
              onTapRepertoire: (day) => cubit.selectRepertoireDay(day.id),
            );
          } else if (state is RepertoireDaySelectTypeState) {
            return SelectRepertoireTypeWidget(
              onSelectType: (index) {
                cubit.selectRepertoireType(index, state.repertoireDay.id);
              },
            );
          }
          // else if (state is RepertoireDaySelectLyricsState) {
          //   return SafeArea(
          //     top: false,
          //     child: Column(
          //       children: [
          //         Expanded(
          //           child: IndexedStack(
          //             index: state.index,
          //             children: state.lyrics
          //                 .map((lyrics) => LyricsScreen(lyrics: lyrics))
          //                 .toList(),
          //           ),
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             IconButton(
          //               icon: const Icon(Icons.arrow_back),
          //               onPressed: state.index > 0
          //                   ? () {
          //                       cubit.previousPage();
          //                     }
          //                   : null,
          //             ),
          //             Text('${state.index + 1} / ${state.lyrics.length}'),
          //             IconButton(
          //               icon: const Icon(Icons.arrow_forward),
          //               onPressed: state.index < state.lyrics.length - 1
          //                   ? () {
          //                       cubit.nextPage();
          //                     }
          //                   : null,
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   );
          // } else if (state is RepertoireDaySelectCipherState) {
          //   return SafeArea(
          //     top: false,
          //     child: Column(
          //       children: [
          //         Expanded(
          //           child: IndexedStack(
          //             index: state.index,
          //             children: state.cipher
          //                 .map((url) => ChiperWebviewScreen(url: url))
          //                 .toList(),
          //           ),
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             IconButton(
          //               icon: const Icon(Icons.arrow_back),
          //               onPressed: state.index > 0
          //                   ? () {
          //                       cubit.previousPage();
          //                     }
          //                   : null,
          //             ),
          //             Text('${state.index + 1} / ${state.cipher.length}'),
          //             IconButton(
          //               icon: const Icon(Icons.arrow_forward),
          //               onPressed: state.index < state.cipher.length - 1
          //                   ? () {
          //                       cubit.nextPage();
          //                     }
          //                   : null,
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   );
          // }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

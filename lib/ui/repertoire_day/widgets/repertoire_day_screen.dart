import 'package:band_app/ui/chiper_webview/widgets/chiper_webview_screen.dart';
import 'package:band_app/ui/repertoire_day/cubits/repertoire_day_cubit.dart';
import 'package:band_app/ui/repertoire_day/cubits/repertoire_day_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class RepertoireDayScreen extends StatefulWidget {
  const RepertoireDayScreen({super.key});

  @override
  State<RepertoireDayScreen> createState() => _RepertoireDayScreenState();
}

class _RepertoireDayScreenState extends State<RepertoireDayScreen> {
  final cubit = GetIt.I<RepertoireDayCubit>();

  @override
  void initState() {
    super.initState();
    cubit.fetchRepertoireDays();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder(
        bloc: cubit,
        builder: (context, state) {
          if (state is RepertoireDayError) {
            return Center(child: Text(state.message));
          } else if (state is RepertoireDayLoaded) {
            return SafeArea(
              top: false,
              child: Column(
                children: [
                  Expanded(
                    child: IndexedStack(
                      index: state.index,
                      children: state.chipers
                          .map((url) => ChiperWebviewScreen(url: url))
                          .toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: state.index > 0
                            ? () {
                                cubit.previousPage();
                              }
                            : null,
                      ),
                      Text('${state.index + 1} / ${state.chipers.length}'),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: state.index < state.chipers.length - 1
                            ? () {
                                cubit.nextPage();
                              }
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

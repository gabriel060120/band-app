import 'package:band_app/ui/repertoire_day/cubits/event_selected_cubit.dart';
import 'package:band_app/ui/repertoire_day/cubits/event_selected_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets.dart';

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
            return EventSelectedWidget(state: state.eventData);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

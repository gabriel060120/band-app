import 'package:band_app/data/repositories/repertoire_day/repertoire_day_repository.dart';
import 'package:band_app/ui/chiper_webview/widgets/chiper_webview_screen.dart';
import 'package:flutter/material.dart';

import '../view_model/repertoire_day_view_model.dart';

class RepertoireDayScreen extends StatefulWidget {
  const RepertoireDayScreen({super.key});

  @override
  State<RepertoireDayScreen> createState() => _RepertoireDayScreenState();
}

class _RepertoireDayScreenState extends State<RepertoireDayScreen> {
  final viewModel = RepertoireDayViewModel(repertoireDayRepository: RepertoireDayRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if(viewModel.loadRepertoire.running) {
            return const Center(child: CircularProgressIndicator());
          }
          else if(viewModel.loadRepertoire.error) {
            return Center(
                child: Text('Ocorreu um erro!'
              ),
            );
          }
          return ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              return PageView(
                // index: viewModel.pageIndex,
                children: viewModel.chipers.map((url) => ChiperWebviewScreen(url: url)).toList(),
              );
            }
          );
        }
      ),
    );
  }
}
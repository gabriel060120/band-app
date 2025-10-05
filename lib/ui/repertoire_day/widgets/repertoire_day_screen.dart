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

  final PageController _pageController = PageController();

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
          return SafeArea(
            top: false,
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) {
                return  Column(
                  children: [
                    Expanded(
                      child: PageView(
                        // index: viewModel.pageIndex,
                        controller: _pageController,
                        physics: NeverScrollableScrollPhysics(),
                        children: viewModel.chipers.map((url) => ChiperWebviewScreen(url: url)).toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: viewModel.pageIndex > 0 ? () {
                            viewModel.previousPage();
                            _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          } : null,
                        ),
                        Text('${viewModel.pageIndex + 1} / ${viewModel.totalPages}'),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: viewModel.pageIndex < viewModel.totalPages - 1 ? () {
                            viewModel.nextPage();
                            _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          } : null,
                        ),
                      ],
                    ),
                  ],
                );
              }
            ),
          );
        }
      ),
    );
  }
}
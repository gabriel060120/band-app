import 'package:flutter/material.dart';

class SelectRepertoireTypeWidget extends StatelessWidget {
  const SelectRepertoireTypeWidget({super.key, required this.onSelectType});
  final void Function(int) onSelectType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => onSelectType(0),
            child: const Text('Letras'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => onSelectType(1),
            child: const Text('Cifras'),
          ),
        ],
      ),
    );
  }
}

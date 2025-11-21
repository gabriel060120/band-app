import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  // tempo total da animação em milissegundos
  final int durationMs;
  // widget para navegar após a splash (opcional)
  final Widget? nextScreen;

  const SplashScreen({super.key, this.durationMs = 1800, this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _rotationAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationMs),
    );

    // Curvas combinadas para dar sensação elegante
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.6,
          end: 1.05,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.05,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
    ]).animate(_controller);

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0)
        .chain(
          CurveTween(curve: const Interval(0.0, 0.75, curve: Curves.easeIn)),
        )
        .animate(_controller);

    _rotationAnim = Tween<double>(
      begin: -0.08,
      end: 0.0,
    ).chain(CurveTween(curve: Curves.easeOutBack)).animate(_controller);

    // ao completar, navega para próxima tela (se houver)
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _goNext();
      }
    });

    // iniciar animação
    _controller.forward();
  }

  void _goNext() {
    if (!mounted) return;
    context.go('/repertoire-day');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnim.value,
                child: Transform.rotate(
                  angle: _rotationAnim.value,
                  child: Transform.scale(scale: _scaleAnim.value, child: child),
                ),
              );
            },
            child: _buildLogo(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    // Ajuste o tamanho conforme necessário
    return Icon(Icons.piano, size: 100);
  }
}

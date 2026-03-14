import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange, 
      body: Center(
        child: Lottie.asset(
          'assets/lottie/Pikachu.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller.duration = composition.duration;

            _controller.forward().then((value) async {
              await Future.delayed(const Duration(seconds: 0));
            }); 
              
              if(mounted){
                context.go('/');
              }
          },
          width: 250,
          height: 250,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
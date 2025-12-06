// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final AnimationController _scaleController;
  late final AnimationController _glowController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Smooth fade-in for entire screen
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    // Gentle breathing effect for icon
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.06,
    ).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );

    // Subtle glow pulse
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.6,
    ).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F766E), // teal-700
              Color(0xFF115E59), // teal-800
              Color(0xFF134E4A), // teal-900
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // App Icon with breathing animation and glow
                  AnimatedBuilder(
                    animation: Listenable.merge([_scaleController, _glowController]),
                    builder: (context, child) {
                      return ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: isTablet ? 160 : 130,
                          height: isTablet ? 160 : 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF14B8A6)
                                    .withOpacity(_glowAnimation.value),
                                blurRadius: 50,
                                spreadRadius: 10,
                                offset: const Offset(0, 10),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 30,
                                offset: const Offset(0, 20),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Image.asset(
                              'assets/app_icon.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF14B8A6),
                                        Color(0xFF06B6D4),
                                      ],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.how_to_vote_rounded,
                                    size: 70,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: isTablet ? 56 : 48),

                  // App Name with elegant styling
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFFFFFFFF),
                        Color(0xFFD1FAE5), // teal-100
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'Probashi Vote Hub',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 34 : 30,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Elegant loading indicator
                  const _LoadingIndicator(),

                  SizedBox(height: isTablet ? 64 : 56),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Refined loading indicator with smooth animation
class _LoadingIndicator extends StatefulWidget {
  const _LoadingIndicator();

  @override
  State<_LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<_LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final delay = index * 0.2;
              final progress = (_controller.value - delay).clamp(0.0, 1.0);
              
              // Smooth bounce animation
              final scale = progress < 0.5
                  ? 1.0 + (progress * 2) * 0.6
                  : 1.6 - ((progress - 0.5) * 2) * 0.6;
              
              final opacity = progress < 0.5
                  ? 0.4 + (progress * 2) * 0.6
                  : 1.0 - ((progress - 0.5) * 2) * 0.4;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF5EEAD4).withOpacity(opacity), // teal-300
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF5EEAD4).withOpacity(opacity * 0.5),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

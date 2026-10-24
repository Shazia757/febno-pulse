import 'dart:async';
import 'package:febno_pulse/database/local_storage.dart';
import 'package:febno_pulse/screens/home_screen.dart';
import 'package:febno_pulse/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _entranceController;
  late final AnimationController _backgroundController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoRotation;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.92, end: 1.06).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _logoRotation = Tween<double>(begin: -0.04, end: 0.04).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeIn,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat(reverse: true);

    _entranceController.forward();
    _startSplash();
  }

  Future<void> _startSplash() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    bool isLoggedIn = false;

    try {
      isLoggedIn = await LocalStorage().isLoggedIn();
    } catch (e) {
      debugPrint('Unable to check login status: $e');
    }

    if (!mounted) return;

    Get.offAll(() => isLoggedIn ? HomeScreen() : const LoginScreen());
  }

  @override
  void dispose() {
    _logoController.dispose();
    _entranceController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return Scaffold(
      backgroundColor: cs.primary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.45, -0.65),
                radius: 1.35,
                colors: [
                  Color.lerp(
                    cs.primary,
                    cs.secondary.withValues(alpha: 0.1),
                    0.45,
                  )!,
                  cs.primary,
                  Color.lerp(cs.primary, Colors.black, 0.22)!,
                ],
              ),
            ),
          ),

          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              final t = _backgroundController.value;

              return Stack(
                children: [
                  Positioned(
                    top: -65 + (t * 22),
                    right: -45,
                    child: IgnorePointer(
                      child: Container(
                        width: 210,
                        height: 210,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cs.onPrimary.withValues(alpha: 0.07),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80 - (t * 28),
                    left: -85,
                    child: IgnorePointer(
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cs.secondary.withValues(alpha: 0.16),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.sizeOf(context).height * 0.28,
                    right: 28 + (t * 12),
                    child: IgnorePointer(
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cs.onPrimary.withValues(alpha: 0.09),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _logoController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _logoRotation.value,
                            child: Transform.scale(
                              scale: _logoScale.value,
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          width: 104,
                          height: 104,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                cs.onPrimary.withValues(alpha: 0.25),
                                cs.onPrimary.withValues(alpha: 0.08),
                              ],
                            ),
                            border: Border.all(
                              color: cs.onPrimary.withValues(alpha: 0.30),
                              width: 1.4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 32,
                                spreadRadius: 2,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: cs.onPrimary.withValues(alpha: 0.10),
                                ),
                              ),

                              Icon(
                                Icons.graphic_eq_rounded,
                                size: 53,
                                color: cs.onPrimary,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      Text(
                        'FebnoPulse',
                        style: tt.headlineMedium?.copyWith(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Every workday, in sync.',
                        textAlign: TextAlign.center,
                        style: tt.bodyLarge?.copyWith(
                          color: cs.onPrimary.withValues(alpha: 0.78),
                          letterSpacing: 0.3,
                        ),
                      ),

                      const SizedBox(height: 42),

                      SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: cs.onPrimary,
                          backgroundColor: cs.onPrimary.withValues(alpha: 0.16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 28,
            child: SafeArea(
              child: Text(
                'MADE FOR EVERY WORKDAY',
                textAlign: TextAlign.center,
                style: tt.labelSmall?.copyWith(
                  color: cs.onPrimary.withValues(alpha: 0.55),
                  letterSpacing: 2.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

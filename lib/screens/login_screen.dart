import 'package:febno_pulse/controllers/account_controller.dart';
import 'package:febno_pulse/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AccountController c;

  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    c = Get.put(AccountController());

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Stack(
        children: [
          Container(
            height: 340,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [cs.primary, cs.primary.withValues(alpha: 0.82)],
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(36),
              ),
            ),
          ),

          Positioned(
            top: -65,
            right: -45,
            child: IgnorePointer(
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cs.onPrimary.withValues(alpha: 0.06),
                ),
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: -65,
            child: IgnorePointer(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cs.onPrimary.withValues(alpha: 0.05),
                ),
              ),
            ),
          ),

          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 48,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 18),

                            Container(
                              width: 66,
                              height: 66,
                              decoration: BoxDecoration(
                                color: cs.onPrimary.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: cs.onPrimary.withValues(alpha: 0.18),
                                ),
                              ),
                              child: Icon(
                                Icons.graphic_eq_rounded,
                                size: 36,
                                color: cs.onPrimary,
                              ),
                            ),

                            const SizedBox(height: 14),

                            Text(
                              'FebnoPulse',
                              style: tt.headlineMedium?.copyWith(
                                color: cs.onPrimary,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Every workday, in sync.',
                              textAlign: TextAlign.center,
                              style: tt.bodyMedium?.copyWith(
                                color: cs.onPrimary.withOpacity(0.78),
                              ),
                            ),

                            const SizedBox(height: 36),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: cs.surface,
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: cs.outline.withOpacity(0.12),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.10),
                                    blurRadius: 30,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Welcome back', style: tt.headlineSmall),

                                  const SizedBox(height: 5),

                                  Text(
                                    'Sign in to manage your attendance '
                                    'and stay connected.',
                                    style: tt.bodySmall?.copyWith(
                                      color: cs.onSurface.withOpacity(0.65),
                                    ),
                                  ),

                                  const SizedBox(height: 22),

                                  Obx(
                                    () => CustomTextField(
                                      label: 'Username',
                                      hint: 'Enter your username',
                                      prefixIcon: Icons.person_outline_rounded,
                                      controller: c.usernameController,
                                      textInputAction: TextInputAction.next,
                                      errorText: c.usernameError.value,
                                      autofillHints: const [
                                        AutofillHints.username,
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  Obx(
                                    () => CustomTextField(
                                      label: 'Password',
                                      hint: 'Enter your password',
                                      prefixIcon: Icons.lock_outline_rounded,
                                      controller: c.passwordController,
                                      isPassword: true,
                                      obscure: c.obscurePassword,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      textInputAction: TextInputAction.done,
                                      autofillHints: const [
                                        AutofillHints.password,
                                      ],
                                      errorText: c.passwordError.value,
                                    ),
                                  ),

                                  const SizedBox(height: 28),
                                  Obx(() {
                                    final isLoading = c.isLoading.value;

                                    return SizedBox(
                                      width: double.infinity,
                                      height: 56,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: cs.primary,
                                          foregroundColor: cs.onPrimary,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                        onPressed: isLoading
                                            ? null
                                            : () => c.login(),
                                        child: isLoading
                                            ? CircularProgressIndicator(
                                                color: cs.onPrimary,
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Sign In',
                                                    style: tt.titleMedium
                                                        ?.copyWith(
                                                          color: cs.onPrimary,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  const Icon(
                                                    Icons.arrow_forward_rounded,
                                                    size: 20,
                                                  ),
                                                ],
                                              ),
                                      ),
                                    );
                                  }),

                                  const SizedBox(height: 14),
                                ],
                              ),
                            ),

                            const SizedBox(height: 26),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

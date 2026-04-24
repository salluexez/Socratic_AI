import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/backend_api_service.dart';
import '../theme/app_theme.dart';
import '../theme/theme_controller.dart';
import '../widgets/ambient_background.dart';
import '../widgets/gradient_button.dart';
import 'home_shell.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignIn = true;
  bool isLoading = false;
  bool hidePassword = true;
  String? errorText;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => ThemeControllerScope.of(context).next(),
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Switch Theme',
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: AmbientBackground(
        child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: palette.primaryDim.withValues(alpha: 0.2), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: palette.primaryDim.withValues(alpha: 0.1),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'assets/logo.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                isSignIn ? 'Welcome back' : 'Create account',
                style: GoogleFonts.outfit(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  color: palette.text,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isSignIn 
                  ? 'Sign in to continue your journey.'
                  : 'Start your guided learning path.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: palette.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: palette.surfaceCard.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: palette.outline.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                    child: Column(
                      children: [
                        _AuthToggle(
                          isSignIn: isSignIn,
                          onChanged: (value) => setState(() => isSignIn = value),
                        ),
                        const SizedBox(height: 32),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: Column(
                            children: [
                              if (!isSignIn) ...[
                                _buildTextField(
                                  controller: nameController,
                                  label: 'Full Name',
                                  icon: Icons.person_outline_rounded,
                                  palette: palette,
                                ),
                                const SizedBox(height: 20),
                              ],
                            ],
                          ),
                        ),
                        _buildTextField(
                          controller: emailController,
                          label: 'Email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          palette: palette,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: passwordController,
                          label: 'Password',
                          icon: Icons.lock_outline_rounded,
                          obscureText: hidePassword,
                          palette: palette,
                          suffix: IconButton(
                            onPressed: () => setState(() => hidePassword = !hidePassword),
                            icon: Icon(
                              hidePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                              size: 20,
                              color: palette.textMuted,
                            ),
                          ),
                        ),
                        if (errorText != null) ...[
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline_rounded, color: Colors.red, size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    errorText!,
                                    style: GoogleFonts.inter(
                                      color: Colors.red,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: GradientButton(
                            label: isSignIn ? 'SIGN IN' : 'CREATE ACCOUNT',
                            onPressed: isLoading ? () {} : _submitAuth,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => isSignIn = !isSignIn),
                  style: TextButton.styleFrom(
                    foregroundColor: palette.textMuted,
                  ),
                  child: Text(
                    isSignIn ? 'Don\'t have an account? Sign Up' : 'Already have an account? Sign In',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
   );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required AppPalette palette,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: palette.primaryDim,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: palette.surfaceLow.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.outline.withValues(alpha: 0.1)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20, color: palette.textMuted),
              suffixIcon: suffix,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              hintText: 'Enter your ${label.toLowerCase()}',
              hintStyle: GoogleFonts.inter(
                color: palette.textMuted.withValues(alpha: 0.4),
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitAuth() async {
    setState(() {
      errorText = null;
    });

    final email = emailController.text.trim();
    final password = passwordController.text;
    final name = nameController.text.trim();
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!BackendApiService.instance.isConfigured) {
      setState(() {
        errorText =
            'API base URL is missing. Run with --dart-define=API_BASE_URL=http://YOUR_SERVER:5000';
      });
      return;
    }

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorText = 'Email and password are required.';
      });
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      setState(() {
        errorText = 'Enter a valid email address.';
      });
      return;
    }

    if (!isSignIn) {
      if (name.isEmpty) {
        setState(() {
          errorText = 'Full name is required.';
        });
        return;
      }

      if (password.length < 8) {
        setState(() {
          errorText = 'Password must be at least 8 characters.';
        });
        return;
      }
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (isSignIn) {
        await BackendApiService.instance.signin(
          email: email,
          password: password,
        );
      } else {
        await BackendApiService.instance.signup(
          name: name,
          email: email,
          password: password,
        );
      }

      await BackendApiService.instance.getMe();

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        HomeShell.routeName,
        (route) => false,
      );
    } on BackendApiException catch (error) {
      setState(() {
        errorText = error.message;
      });
    } catch (_) {
      setState(() {
        errorText =
            'Unable to complete authentication. Check API URL, backend server, and cookie auth setup.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}

class _AuthToggle extends StatelessWidget {
  const _AuthToggle({
    required this.isSignIn,
    required this.onChanged,
  });

  final bool isSignIn;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: palette.surfaceLow.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: palette.outline.withValues(alpha: 0.1)),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutBack,
            alignment: isSignIn ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: palette.surfaceCard.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _ToggleButton(
                  label: 'Sign In',
                  isActive: isSignIn,
                  onTap: () => onChanged(true),
                ),
              ),
              Expanded(
                child: _ToggleButton(
                  label: 'Sign Up',
                  isActive: !isSignIn,
                  onTap: () => onChanged(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: isActive 
                  ? palette.primaryDim 
                  : palette.textMuted,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
          child: Text(label),
        ),
      ),
    );
  }
}

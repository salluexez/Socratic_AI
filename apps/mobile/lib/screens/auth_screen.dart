import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/app_config.dart';
import '../services/backend_api_service.dart';
import '../theme/app_theme.dart';
import '../theme/theme_controller.dart';
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
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => ThemeControllerScope.of(context).next(),
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Switch Theme',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: palette.primaryDim.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.asset(
                      'assets/logo.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                    child: child,
                  ),
                ),
                child: Text(
                  isSignIn ? 'Welcome back' : 'Create account',
                  key: ValueKey(isSignIn),
                  style: GoogleFonts.cookie(
                    textStyle: Theme.of(context).textTheme.displayMedium,
                    fontSize: 48,
                    height: 1.0,
                    color: palette.primaryDim,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  isSignIn 
                    ? 'Start your guided learning journey with a calm Socratic companion.'
                    : 'Join a community of critical thinkers and start your learning journey.',
                  key: ValueKey(isSignIn),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: palette.textMuted,
                      ),
                ),
              ),
              const SizedBox(height: 28),
              _AuthToggle(
                isSignIn: isSignIn,
                onChanged: (value) => setState(() => isSignIn = value),
              ),
              const SizedBox(height: 24),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Column(
                  children: [
                    if (!isSignIn) ...[
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full name',
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: hidePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submitAuth(),
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                  ),
                ),
              ),
              if (errorText != null) ...[
                const SizedBox(height: 16),
                Text(
                  errorText!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.red,
                      ),
                ),
              ],
              const SizedBox(height: 24),
              GradientButton(
                label: isSignIn ? 'Sign In' : 'Create Account',
                onPressed: isLoading ? () {} : _submitAuth,
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => isSignIn = !isSignIn),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      isSignIn
                          ? 'Need an account? Sign Up'
                          : 'Already have an account? Sign In',
                      key: ValueKey(isSignIn),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: palette.surfaceLow,
        borderRadius: BorderRadius.circular(999),
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
                  color: palette.surfaceCard,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: isActive 
                  ? (isDark ? Colors.white : palette.primaryDim) 
                  : palette.textMuted,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
          child: Text(label),
        ),
      ),
    );
  }
}

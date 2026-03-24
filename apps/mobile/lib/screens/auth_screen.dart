import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
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

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isSignIn ? 'Welcome back' : 'Create your account',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Start your guided learning journey with a calm Socratic companion.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: palette.textMuted,
                    ),
              ),
              const SizedBox(height: 28),
              _AuthToggle(
                isSignIn: isSignIn,
                onChanged: (value) => setState(() => isSignIn = value),
              ),
              const SizedBox(height: 24),
              if (!isSignIn) ...[
                const TextField(
                    decoration: InputDecoration(labelText: 'Full name')),
                const SizedBox(height: 16),
              ],
              const TextField(decoration: InputDecoration(labelText: 'Email')),
              const SizedBox(height: 16),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              if (!isSignIn) ...[
                const SizedBox(height: 16),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Confirm password'),
                ),
              ],
              const SizedBox(height: 24),
              GradientButton(
                label: isSignIn ? 'Sign In' : 'Create Account',
                onPressed: () => Navigator.pushReplacementNamed(
                    context, HomeShell.routeName),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => isSignIn = !isSignIn),
                  child: Text(
                    isSignIn
                        ? 'Need an account? Sign Up'
                        : 'Already have an account? Sign In',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: palette.surfaceLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? palette.surfaceCard : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isActive ? AppColors.primary : palette.textMuted,
                ),
          ),
        ),
      ),
    );
  }
}

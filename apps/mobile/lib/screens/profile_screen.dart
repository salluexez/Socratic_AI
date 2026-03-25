import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/api_session.dart';
import '../models/api_user.dart';
import '../services/app_config.dart';
import '../services/backend_api_service.dart';
import '../theme/app_theme.dart';
import '../theme/theme_controller.dart';
import 'auth_screen.dart';
import 'explore_courses_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  ApiUser? user;
  List<ApiSession> sessions = const [];

  @override
  void initState() {
    super.initState();
    BackendApiService.instance.refreshNotifier.addListener(_loadProfile);
    _loadProfile();
  }

  @override
  void dispose() {
    BackendApiService.instance.refreshNotifier.removeListener(_loadProfile);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final themeController = ThemeControllerScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Derived stats
    final totalSeconds = sessions.fold<int>(
      0,
      (sum, session) => sum + (session.duration ?? 0).toInt(),
    );
    final totalHours = (totalSeconds / 3600).toStringAsFixed(1);
    
    // Safety Fallback User
    final displayUser = user ?? ApiUser(
      id: 'mock',
      name: 'Scholar Student',
      email: 'hello@${AppConfig.appName.toLowerCase().replaceAll(' ', '')}.ai',
    );

    return Container(
      color: palette.surfaceLow,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Header / App Bar Simulation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Your ',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: palette.textMuted,
                                letterSpacing: -0.5,
                              ),
                            ),
                            TextSpan(
                              text: 'Profile',
                              style: GoogleFonts.inter(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: palette.text,
                                letterSpacing: -1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Hero Avatar Section
                    GestureDetector(
                      onTap: _showEditProfileDialog,
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [palette.primaryDim, palette.secondaryContainer],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: palette.primaryDim.withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 56,
                              backgroundColor: palette.surfaceCard,
                              child: Icon(Icons.person_rounded, 
                                size: 60, color: palette.primaryDim),
                            ),
                          ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: palette.primaryDim,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: palette.surfaceLow, width: 3),
                                ),
                                child: Icon(Icons.edit_rounded, 
                                  color: Colors.white, size: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            displayUser.name,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            displayUser.email,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: palette.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Modern Stats Bar
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: palette.surfaceCard,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black.withValues(alpha: 0.2) : palette.text.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _VerticalStat(
                            icon: Icons.auto_graph_rounded,
                            value: '${sessions.length}',
                            label: 'Sessions',
                            color: palette.primaryDim,
                          ),
                          _StatDivider(palette: palette),
                          _VerticalStat(
                            icon: Icons.timer_rounded,
                            value: totalHours,
                            label: 'Hours',
                            color: const Color(0xFF00BFA5),
                          ),
                          _StatDivider(palette: palette),
                          _VerticalStat(
                            icon: Icons.local_fire_department_rounded,
                            value: '4', // Mock streak
                            label: 'Streak',
                            color: const Color(0xFFFF9100),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Action Group: Account
                    _SectionHeader(title: 'Account Settings'),
                    const SizedBox(height: 12),
                    _ActionTile(
                      icon: Icons.person_outline_rounded,
                      title: 'Edit Profile',
                      subtitle: 'Update your display name',
                      onTap: _showEditProfileDialog,
                    ),
                    const SizedBox(height: 12),

                    const SizedBox(height: 12),
                    _ActionTile(
                      icon: Icons.shield_outlined,
                      title: 'Privacy & Security',
                      subtitle: 'Managed shared data',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    const SizedBox(height: 28),

                    // Action Group: Support
                    _SectionHeader(title: 'General'),
                    const SizedBox(height: 12),
                    _ActionTile(
                      icon: Icons.explore_rounded,
                      title: 'Explore Courses',
                      subtitle: 'Discover and add more subjects to your path',
                      onTap: () {
                        Navigator.pushNamed(context, ExploreCoursesScreen.routeName);
                      },
                    ),
                    const SizedBox(height: 12),
                    _ActionTile(
                      icon: Icons.logout_rounded,
                      title: 'Log Out',
                      subtitle: 'Securely end session',
                      color: Colors.redAccent,
                      onTap: () async {
                        await BackendApiService.instance.logout();
                        if (!mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AuthScreen.routeName,
                          (route) => false,
                        );
                      },
                    ),
                    
                    const SizedBox(height: 120), // Space for nav bar
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _showEditProfileDialog() async {
    if (user == null) return;
    
    final nameController = TextEditingController(text: user!.name);
    final palette = context.palette;
    
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: palette.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text('Edit Name', style: GoogleFonts.inter(fontWeight: FontWeight.w700, letterSpacing: -0.5)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your name will be visible across the platform.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: palette.textMuted),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              autofocus: true,
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person_outline_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: palette.textMuted, fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, nameController.text.trim()),
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.primaryDim,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && newName != user?.name) {
      try {
        setState(() => isLoading = true);
        await BackendApiService.instance.updateMe(name: newName);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      } finally {
        if (mounted) setState(() => isLoading = false);
      }
    }
  }

  Future<void> _loadProfile() async {
    try {
      final currentUser = await BackendApiService.instance.getMe();
      final sessionList = await BackendApiService.instance.getSessions();
      if (!mounted) return;
      setState(() {
        user = currentUser;
        sessions = sessionList;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isLoading = false; // Still allow UI to show with defaults
      });
    }
  }
}

class _VerticalStat extends StatelessWidget {
  const _VerticalStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: palette.textMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider({required this.palette});
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.5,
      height: 40,
      color: palette.text.withValues(alpha: 0.05),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: context.palette.textMuted,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.color,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: palette.surfaceCard,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.2) : palette.text.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (color ?? palette.primaryDim).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color ?? palette.primaryDim, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: palette.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, 
              color: palette.text.withValues(alpha: 0.1), size: 16),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../controllers/course_controller.dart';
import '../theme/app_theme.dart';

class ExploreCoursesScreen extends StatelessWidget {
  static const routeName = '/explore-courses';

  const ExploreCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final courseController = CourseControllerScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Courses'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<String>>(
        valueListenable: courseController,
        builder: (context, selectedSlugs, _) {
          final allSubjects = courseController.allSubjects;

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: allSubjects.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: 72,
              endIndent: 24,
              color: palette.outline.withValues(alpha: 0.5),
            ),
            itemBuilder: (context, index) {
              final subject = allSubjects[index];
              final isSelected = courseController.isSelected(subject.slug);
              final isPermanent = subject.isPermanent;

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: subject.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    subject.icon,
                    color: subject.accent,
                  ),
                ),
                title: Text(
                  subject.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                subtitle: Text(
                  isPermanent ? 'Core Course (Permanent)' : subject.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isPermanent ? subject.accent : palette.textMuted,
                      ),
                ),
                trailing: isPermanent
                    ? Icon(Icons.lock_outline, color: palette.textMuted, size: 20)
                    : Checkbox(
                        value: isSelected,
                        onChanged: (_) => courseController.toggleCourse(subject.slug),
                        activeColor: subject.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                onTap: isPermanent ? null : () => courseController.toggleCourse(subject.slug),
              );
            },
          );
        },
      ),
    );
  }
}

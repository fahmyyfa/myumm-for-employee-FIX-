import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppHeader extends StatelessWidget {
  final String? subtitle;
  final String title;
  final Widget? trailing;
  final double height;

  const AppHeader({
    super.key,
    this.subtitle,
    required this.title,
    this.trailing,
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        letterSpacing: 1,
                      ),
                    ),
                  if (subtitle != null) const SizedBox(height: 4),
                  Text(
                    title,
                    style: AppTextStyles.heading2.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class AppHeaderSmall extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? tags;

  const AppHeaderSmall({
    super.key,
    required this.title,
    this.subtitle,
    this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (subtitle != null)
            Text(
              subtitle!,
              style: AppTextStyles.caption.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          if (subtitle != null) const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.subtitle1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (tags != null) ...tags!,
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
        title: const Text('Notifikasi'),
        centerTitle: true,
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TERBARU', style: AppTextStyles.chipText.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0)),
            const SizedBox(height: 16),
            _buildNotificationCard('Informasi Eligible Kenaikan Pangkat', 'Lengkapi berkas dan dokumen sebelum melakukan submit', '2m ago', isUnread: true),
            _buildNotificationCard('Informasi Eligible Kenaikan Pangkat', 'Lengkapi berkas dan dokumen sebelum melakukan submit', '1h ago', isUnread: true),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(String title, String subtitle, String time, {bool isUnread = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: isUnread ? const Color(0xFF1550B0) : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(title, style: AppTextStyles.subtitle2)),
                    const SizedBox(width: 8),
                    Text(time, style: AppTextStyles.caption.copyWith(color: AppColors.textHint)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

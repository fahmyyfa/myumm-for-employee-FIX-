import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/academic_rank_provider.dart';
import '../domain/academic_rank_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/domain/profile_model.dart';

class AcademicRankScreen extends ConsumerStatefulWidget {
  const AcademicRankScreen({super.key});

  @override
  ConsumerState<AcademicRankScreen> createState() => _AcademicRankScreenState();
}

class _AcademicRankScreenState extends ConsumerState<AcademicRankScreen> {
  // Track which item is expanded (initially the first one)
  int _expandedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ranksAsync = ref.watch(academicRankProvider);
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
        title: const Text('Jab. Akademik'),
        centerTitle: true,
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) return const Center(child: Text('Profile tidak ditemukan'));
          
          return ranksAsync.when(
            data: (ranks) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(profile),
                    const SizedBox(height: 24),
                    
                    Text('Daftar Riwayat', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                    Text('Jabatan Akademik', style: AppTextStyles.heading1),
                    const SizedBox(height: 16),
                    
                    // Rank List
                    ...ranks.asMap().entries.map((entry) {
                      final index = entry.key;
                      final rank = entry.value;
                      final isExpanded = index == _expandedIndex;
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _expandedIndex = isExpanded ? -1 : index;
                          });
                        },
                        child: isExpanded 
                            ? _buildExpandedCard(rank) 
                            : _buildCollapsedCard(rank),
                      );
                    }),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(e.toString())),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileModel profile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(child: Icon(Icons.person, size: 40, color: Colors.white.withValues(alpha: 0.8))),
                Positioned(
                  bottom: -8, left: 0, right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1550B0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('VERIFIED', style: AppTextStyles.caption.copyWith(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile.fullName, style: AppTextStyles.subtitle1),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.scaffoldBackground, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.badge_outlined, size: 12, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('NIP: ${profile.nip}', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text('Dosen Tetap • Teknik Informatika', style: AppTextStyles.caption.copyWith(color: AppColors.textHint, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedCard(AcademicRankModel rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC), // very light blue/grey
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44, height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F0FE),
                  shape: BoxShape.circle,
                ),
                child: const Center(child: Icon(Icons.workspace_premium, color: Color(0xFF1550B0), size: 24)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('JABATAN AKADEMIK', style: AppTextStyles.chipText.copyWith(color: const Color(0xFF64748B), letterSpacing: 0.5)),
                    const SizedBox(height: 2),
                    Text(rank.rankName, style: AppTextStyles.heading3.copyWith(color: const Color(0xFF1550B0))),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('KUM SCORE', style: AppTextStyles.chipText.copyWith(color: const Color(0xFF64748B), letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3470), // Dark blue
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(rank.kum.toString(), style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Grid
          Row(
            children: [
              Expanded(child: _buildGridItem(Icons.calendar_today_outlined, 'TMT DIKTI', rank.tmtDikti)),
              const SizedBox(width: 12),
              Expanded(child: _buildGridItem(Icons.calendar_today_outlined, 'TMT UMM', rank.tmtUmm)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildGridItem(Icons.description_outlined, 'NO SK DIKTI', rank.noSkDikti)),
              const SizedBox(width: 12),
              Expanded(child: _buildGridItem(Icons.description_outlined, 'NO SK UMM', rank.noSkUmm)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildGridItem(Icons.description_outlined, 'TGL SK DIKTI', rank.tglSkDikti)),
              const SizedBox(width: 12),
              Expanded(child: _buildGridItem(Icons.description_outlined, 'TGL SK UMM', rank.tglSkUmm)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
              const SizedBox(width: 6),
              Text(label, style: AppTextStyles.caption.copyWith(color: const Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF1E293B))),
        ],
      ),
    );
  }

  Widget _buildCollapsedCard(AcademicRankModel rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9), // light grey circle
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Center(child: Icon(Icons.workspace_premium_outlined, color: Color(0xFF94A3B8), size: 20)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rank.rankName.toUpperCase(), style: AppTextStyles.chipText.copyWith(color: const Color(0xFF94A3B8), letterSpacing: 0.5)),
                const SizedBox(height: 2),
                Text(rank.rankName, style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF334155))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('KUM: ${rank.kum}', style: AppTextStyles.caption.copyWith(color: const Color(0xFF64748B), fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1), size: 20),
        ],
      ),
    );
  }
}

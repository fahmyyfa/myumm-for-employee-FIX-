import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/providers/profile_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../activities/providers/activity_attendance_provider.dart';
import '../../schedule/providers/schedule_provider.dart';
import '../../../core/widgets/loading_shimmer.dart';
import '../../../core/widgets/empty_state.dart';
import 'dosen_home_content.dart';
import 'karyawan_home_content.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return profileAsync.when(
      data: (profile) {
        debugPrint('HOME SCREEN: Profile loaded with role: ${profile?.roleType}');
        if (profile == null) {
          return Scaffold(
            body: EmptyState(
              title: 'Profil tidak ditemukan',
              subtitle: 'Gagal memuat data profil. Silakan coba lagi.',
              icon: Icons.person_off_rounded,
              action: ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(profileProvider);
                  ref.invalidate(userIdProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(profileProvider);
            ref.invalidate(activityAttendanceProvider);
            ref.invalidate(schedulesProvider);
          },
          child: profile.isDosen
              ? DosenHomeContent(profile: profile)
              : KaryawanHomeContent(profile: profile),
        );
      },
      loading: () => Scaffold(
        body: SafeArea(child: Padding(
          padding: const EdgeInsets.all(20),
          child: ShimmerList(itemCount: 4, itemHeight: 100),
        )),
      ),
      error: (e, _) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Terjadi kesalahan: $e'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(profileProvider),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

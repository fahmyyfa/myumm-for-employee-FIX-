import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/providers/profile_provider.dart';
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
        if (profile == null) {
          return const Scaffold(body: EmptyState(title: 'Profil tidak ditemukan'));
        }
        return profile.isDosen
            ? DosenHomeContent(profile: profile)
            : KaryawanHomeContent(profile: profile);
      },
      loading: () => Scaffold(
        body: SafeArea(child: Padding(
          padding: const EdgeInsets.all(20),
          child: ShimmerList(itemCount: 4, itemHeight: 100),
        )),
      ),
      error: (e, _) => Scaffold(body: ErrorState(message: e.toString())),
    );
  }
}

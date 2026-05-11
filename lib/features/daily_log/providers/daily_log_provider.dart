import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/daily_log_model.dart';
import '../../profile/providers/profile_provider.dart';

final dailyLogsProvider = FutureProvider<List<DailyLogModel>>((ref) async {
  final profile = await ref.watch(profileProvider.future);
  if (profile == null) return [];
  return DailyLogModel.demoData(profile.id);
});

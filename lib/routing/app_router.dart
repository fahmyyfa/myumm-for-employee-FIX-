
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/domain/auth_state.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/profile/providers/profile_provider.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/history/presentation/history_screen.dart';
import '../features/history/presentation/history_detail_screen.dart';
import '../features/achievements/presentation/achievement_screen.dart';
import '../features/achievements/presentation/achievement_detail_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/profile/presentation/biodata_screen.dart';
import '../features/profile/presentation/biodata_full_screen.dart';
import '../features/profile/presentation/family_form_screen.dart';
import '../features/tugas_akhir/presentation/tugas_akhir_screen.dart';
import '../features/tugas_akhir/presentation/tugas_akhir_detail_screen.dart';
import '../features/notification/presentation/notification_screen.dart';
import '../features/scan/presentation/scan_screen.dart';
import '../features/schedule/presentation/schedule_screen.dart';
import '../features/schedule/presentation/schedule_detail_screen.dart';
import '../features/attendance/presentation/attendance_detail_screen.dart';
import '../features/attendance/presentation/daily_attendance_screen.dart';
import '../features/activities/presentation/activity_attendance_screen.dart';
import '../features/history/presentation/academic_rank_screen.dart';
import '../features/daily_log/presentation/daily_log_screen.dart';
import '../features/obe/presentation/obe_main_screen.dart';
import '../features/obe/presentation/obe_course_detail_screen.dart';
import '../features/obe/presentation/obe_grade_distribution_screen.dart';
import '../features/obe/presentation/obe_evaluation_screen.dart';
import '../features/obe/presentation/obe_jurnal_list_screen.dart';
import '../features/obe/presentation/obe_jurnal_detail_screen.dart';
import '../features/obe/presentation/obe_capaian_list_screen.dart';
import '../features/obe/presentation/obe_capaian_detail_screen.dart';
import '../features/obe/presentation/obe_evaluasi_materi_screen.dart';
import '../features/obe/presentation/obe_kinerja_list_screen.dart';
import '../features/obe/presentation/obe_kinerja_detail_screen.dart';
import '../features/obe/presentation/obe_evaluation_detail_screen.dart';
import '../shared/navigation/main_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authChangeNotifier = ref.read(authChangeNotifierProvider);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: authChangeNotifier,
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final isAuth = authState.status == AuthStatus.authenticated;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isAuth && !isLoginRoute) return '/login';
      
      if (isAuth) {
        if (isLoginRoute || state.matchedLocation == '/home' || state.matchedLocation == '/') {
          // Check the profile role if available
          final profile = ref.read(profileProvider).value;
          if (profile != null) {
            if (profile.roleType.trim().toLowerCase() == 'karyawan') return '/karyawan-home';
            if (profile.roleType.trim().toLowerCase() == 'dosen') return '/dosen-home';
            return '/home'; // Loading/Fallback
          }
          // Default fallback while profile is loading
          return '/home';
        }
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/dosen-home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/karyawan-home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/history',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HistoryScreen(),
            ),
          ),
          GoRoute(
            path: '/scan',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ScanScreen(),
            ),
          ),
          GoRoute(
            path: '/achievements',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AchievementScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
      // Non-shell routes (detail pages)
      GoRoute(
        path: '/history/:category',
        builder: (context, state) => HistoryDetailScreen(
          category: state.pathParameters['category'] ?? '',
        ),
      ),
      GoRoute(
        path: '/achievements/detail/:category',
        builder: (context, state) => AchievementDetailScreen(
          category: state.pathParameters['category'] ?? '',
        ),
      ),
      GoRoute(
        path: '/achievements/:category',
        redirect: (context, state) {
          final category = state.pathParameters['category'];
          return '/achievements/detail/$category';
        },
      ),
      GoRoute(
        path: '/profile/family/add',
        builder: (context, state) => const FamilyFormScreen(),
      ),
      GoRoute(
        path: '/profile/biodata',
        builder: (context, state) => const BiodataScreen(),
      ),
      GoRoute(
        path: '/profile/biodata/full',
        builder: (context, state) => const BiodataFullScreen(),
      ),
      GoRoute(
        path: '/profile/family/:id/edit',
        builder: (context, state) => FamilyFormScreen(
          familyMemberId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: '/tugas-akhir',
        builder: (context, state) => const TugasAkhirScreen(),
      ),
      GoRoute(
        path: '/tugas-akhir/detail',
        builder: (context, state) => TugasAkhirDetailScreen(
          role: state.uri.queryParameters['role'] ?? 'pembimbing',
        ),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: '/schedule',
        builder: (context, state) => const ScheduleScreen(),
      ),
      GoRoute(
        path: '/schedule/:id',
        builder: (context, state) => ScheduleDetailScreen(
          scheduleId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/obe',
        builder: (context, state) => const ObeMainScreen(),
      ),
      GoRoute(
        path: '/obe/course/:id',
        builder: (context, state) => ObeCourseDetailScreen(
          courseId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/obe/course/:id/grades',
        builder: (context, state) => ObeGradeDistributionScreen(
          courseId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/obe/course/:id/evaluation',
        builder: (context, state) => ObeEvaluationScreen(
          courseId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/obe/course/:id/evaluation/:classId',
        builder: (context, state) => ObeEvaluationDetailScreen(
          courseId: state.pathParameters['id'] ?? '',
          classId: state.pathParameters['classId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/obe/course/:id/kinerja',
        builder: (context, state) => ObeKinerjaListScreen(
          courseId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/obe/course/:id/kinerja/:classId',
        builder: (context, state) => ObeKinerjaDetailScreen(
          courseId: state.pathParameters['id'] ?? '',
          classId: state.pathParameters['classId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/obe/course/:id/jurnal',
        builder: (context, state) => ObeJurnalListScreen(
          courseId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/obe/course/:id/jurnal/:classId',
        builder: (context, state) => ObeJurnalDetailScreen(
          courseId: state.pathParameters['id'] ?? '',
          classId: state.pathParameters['classId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/obe/course/:id/capaian',
        builder: (context, state) => ObeCapaianListScreen(
          courseId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/obe/course/:id/capaian/:classId',
        builder: (context, state) => ObeCapaianDetailScreen(
          courseId: state.pathParameters['id'] ?? '',
          classId: state.pathParameters['classId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/obe/course/:id/evaluasi_materi',
        builder: (context, state) => ObeEvaluasiMateriScreen(
          courseId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/attendance/daily',
        builder: (context, state) => const DailyAttendanceScreen(),
      ),
      GoRoute(
        path: '/activities/attendance',
        builder: (context, state) => const ActivityAttendanceScreen(),
      ),
      GoRoute(
        path: '/academic-ranks',
        builder: (context, state) => const AcademicRankScreen(),
      ),
      GoRoute(
        path: '/attendance/:scheduleId',
        builder: (context, state) => AttendanceDetailScreen(
          scheduleId: state.pathParameters['scheduleId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/daily-log',
        builder: (context, state) => const DailyLogScreen(),
      ),
    ],
  );
});

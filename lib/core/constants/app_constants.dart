class AppConstants {
  AppConstants._();

  // Supabase credentials
  static const String supabaseUrl = 'https://ejtrpffqxqrqbetpuwqe.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVqdHJwZmZxeHFycWJldHB1d3FlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgzOTExODMsImV4cCI6MjA5Mzk2NzE4M30.x_ONs20kfPn5NKuRpTM6ZoOZwfC8Gg_w0GAYi6qjhTk';

  // App info
  static const String appName = 'MyUMM For Employee';
  static const String appVersion = '1.0.0';
  static const String universityName = 'Universitas Muhammadiyah Malang';
  static const String copyrightYear = '2024';

  // Table names
  static const String profilesTable = 'profiles';
  static const String familyMembersTable = 'family_members';
  static const String teachingSchedulesTable = 'teaching_schedules';
  static const String studentAttendanceTable = 'student_attendance';
  static const String employmentHistoriesTable = 'employment_histories';
  static const String achievementsTable = 'achievements';
  static const String dailyLogsTable = 'daily_logs';
  static const String activitiesTable = 'activities';

  // Roles
  static const String roleDosen = 'dosen';
  static const String roleKaryawan = 'karyawan';

  // Attendance statuses
  static const String statusHadir = 'Hadir';
  static const String statusSakit = 'Sakit';
  static const String statusIjin = 'Ijin';
  static const String statusAlpha = 'Alpha';

  // History categories
  static const List<String> historyCategories = [
    'Pendidikan',
    'Kepangkatan',
    'Aktifasi',
    'Kerja di UMM',
    'Kepanitiaan',
    'Organisasi',
    'Prestasi',
  ];

  // Achievement categories
  static const List<String> achievementCategories = [
    'Kegiatan Ilmiah',
    'Aktifitas Sosial',
    'Pelatihan',
    'Studi Lanjut',
  ];

  // Family relationships
  static const List<String> familyRelationships = [
    'Suami',
    'Istri',
    'Anak',
    'Ayah',
    'Ibu',
    'Saudara',
    'Lainnya',
  ];
}

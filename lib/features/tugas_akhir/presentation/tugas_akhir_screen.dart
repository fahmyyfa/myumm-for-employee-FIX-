import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class TugasAkhirScreen extends StatefulWidget {
  const TugasAkhirScreen({super.key});

  @override
  State<TugasAkhirScreen> createState() => _TugasAkhirScreenState();
}

class _TugasAkhirScreenState extends State<TugasAkhirScreen> {
  int _selectedTab = 0; // 0: Pembimbing, 1: Penguji, 2: Lulus

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
        title: const Text('Tugas Akhir'),
        centerTitle: true,
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Bimbingan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('PROGRESS BIMBINGAN', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 6, color: Color(0xFF1550B0)),
                      const SizedBox(width: 4),
                      Text('1 ACTIVE', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontSize: 8, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildProgressCard('01', 'Bab I: Pendahuluan', '0 Mahasiswa'),
            _buildProgressCard('01', 'Bab II: Pendahuluan', '0 Mahasiswa'),
            _buildProgressCard('01', 'Bab III: Pendahuluan', '0 Mahasiswa'),
            _buildProgressCard('01', 'Bab IV: Pendahuluan', '0 Mahasiswa'),
            _buildProgressCard('01', 'Bab V: Pendahuluan', '0 Mahasiswa'),
            
            const SizedBox(height: 24),
            
            // Cek Judul Mahasiswa
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('CEK JUDUL MAHASISWA', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                const Icon(Icons.filter_list, color: Color(0xFF1550B0), size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Column(
                children: [
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldBackground,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search by name, NIM, or topic...',
                              hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildJudulCard('SITI AMINAH', '2000000001', '"Analisis Sentimen Terhadap Kebijakan Akademik Kampus Menggunakan Arsitektur Model BERT"'),
                  _buildJudulCard('SITI AMINAH', '2000000001', '"Analisis Sentimen Terhadap Kebijakan Akademik Kampus Menggunakan Arsitektur Model BERT"'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Stats Grid
            Row(
              children: [
                Expanded(child: _buildStatCard(Icons.groups, '12', 'PEMBIMBING')),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard(Icons.co_present, '08', 'PENGUJI')),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard(Icons.check_circle_outline, '45', 'LULUS', isSuccess: true)),
              ],
            ),
            const SizedBox(height: 24),
            
            // Tabs
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.scaffoldBackground,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildTabButton(0, 'Pembimbing')),
                  Expanded(child: _buildTabButton(1, 'Penguji')),
                  Expanded(child: _buildTabButton(2, 'Lulus')),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // List of students
            if (_selectedTab == 0) ...[
              _buildStudentTugasCard('pembimbing', '2024/SK-PB/102', 'Ahmad Sulaiman Al-Fatih', '1204120001', '142 Hari', progress: '85% DONE', progressColor: const Color(0xFF1550B0), progressBg: const Color(0xFFE8F0FE)),
              _buildStudentTugasCard('pembimbing', '2023/SK-PB/089', 'Sarah Anindya Putri', '1204120045', '45 Hari', progress: '32% ACTIVE', progressColor: const Color(0xFFC026A6), progressBg: const Color(0xFFFDE8F7)),
            ] else if (_selectedTab == 1) ...[
              _buildStudentTugasCard('penguji', '2024/SK-PB/102', 'Ahmad Sulaiman Al-Fatih', '1204120001', '142 Hari', tanggalSidang: '4 Okt 2026'),
              _buildStudentTugasCard('penguji', '2023/SK-PB/089', 'Sarah Anindya Putri', '1204120045', '45 Hari', tanggalSidang: '12 Nov 2026'),
            ] else ...[
              _buildStudentLulusCard('1', '20230000000001', 'Andi Wijaya', 'Optimasi Algoritma Enkripsi Data pada Jaringan Sensor Nirkabel Berbasis IoT', '12 Jul 2023', '20 Aug 2023'),
              _buildStudentLulusCard('2', '20230000000001', 'Andi Wijaya', 'Optimasi Algoritma Enkripsi Data pada Jaringan Sensor Nirkabel Berbasis IoT', '12 Jul 2023', '20 Aug 2023'),
              _buildStudentLulusCard('3', '20230000000001', 'Andi Wijaya', 'Optimasi Algoritma Enkripsi Data pada Jaringan Sensor Nirkabel Berbasis IoT', '12 Jul 2023', '20 Aug 2023'),
            ],
            
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.white,
                ),
                child: Text('LIHAT SEMUA DATA', style: AppTextStyles.button.copyWith(color: const Color(0xFF1550B0))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(String index, String title, String subtitle) {
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
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(8)),
            child: Text(index, style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF1550B0))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.subtitle2),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
        ],
      ),
    );
  }

  Widget _buildJudulCard(String name, String nim, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontSize: 10, fontWeight: FontWeight.bold)),
          Text(nim, style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF1550B0))),
          const SizedBox(height: 8),
          Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, {bool isSuccess = false}) {
    final color = isSuccess ? const Color(0xFF1A9A5B) : const Color(0xFF1550B0);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.heading2),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 9)),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1550B0) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(label, style: AppTextStyles.subtitle2.copyWith(color: isSelected ? Colors.white : AppColors.textSecondary)),
        ),
      ),
    );
  }

  Widget _buildStudentTugasCard(String role, String sk, String name, String nim, String duration, {String? progress, Color? progressColor, Color? progressBg, String? tanggalSidang}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 4,
            decoration: const BoxDecoration(
              color: Color(0xFF1550B0),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(role == 'pembimbing' ? 'NO. SK PEMBIMBING' : 'NO. SK PENGUJI', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 8, fontWeight: FontWeight.bold)),
                          Text(sk, style: AppTextStyles.subtitle2),
                        ],
                      ),
                      if (progress != null) Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: progressBg, borderRadius: BorderRadius.circular(12)),
                        child: Text(progress, style: AppTextStyles.caption.copyWith(color: progressColor, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(name, style: AppTextStyles.subtitle1),
                  Text('NIM: $nim', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  
                  if (role == 'pembimbing') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('LAMA PENGERJAAN', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 8, fontWeight: FontWeight.bold)),
                            Text(duration, style: AppTextStyles.subtitle2),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () => context.push('/tugas-akhir/detail?role=$role'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3F82F7),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            minimumSize: const Size(0, 32),
                          ),
                          child: Text('Detail', style: AppTextStyles.button.copyWith(fontSize: 12)),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('LAMA PENGERJAAN', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 8, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(duration, style: AppTextStyles.subtitle2),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () => context.push('/tugas-akhir/detail?role=$role'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3F82F7),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  minimumSize: const Size(0, 32),
                                ),
                                child: Text('Detail', style: AppTextStyles.button.copyWith(fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                        if (tanggalSidang != null) Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('TANGGAL SIDANG', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 8, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(tanggalSidang, style: AppTextStyles.subtitle2),
                              const SizedBox(height: 44), // Alignment spacing
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildStudentLulusCard(String index, String nim, String name, String title, String tglSidang, String tglLulus) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
                child: Text(nim, style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold)),
              ),
              Container(
                width: 24, height: 24,
                decoration: const BoxDecoration(color: Color(0xFFE8F0FE), shape: BoxShape.circle),
                child: Center(child: Text(index, style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold))),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(name, style: AppTextStyles.subtitle1),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF1550B0)),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TANGGAL SIDANG', style: AppTextStyles.caption.copyWith(color: AppColors.textHint, fontSize: 8, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(tglSidang, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.school_outlined, size: 16, color: Color(0xFF531E69)), // Adjusted icon to graduation cap like
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TANGGAL LULUS', style: AppTextStyles.caption.copyWith(color: AppColors.textHint, fontSize: 8, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(tglLulus, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

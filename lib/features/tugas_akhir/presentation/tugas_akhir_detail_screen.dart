import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class TugasAkhirDetailScreen extends StatelessWidget {
  final String role; // 'pembimbing' or 'penguji' or 'lulus'
  
  const TugasAkhirDetailScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
        title: const Text('Detail Mahasiswa'),
        centerTitle: true,
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Identitas Mahasiswa
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('IDENTITAS MAHASISWA', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  Text('Ahmad Sulaiman Al-Fatih', style: AppTextStyles.subtitle1.copyWith(fontSize: 18)),
                  const SizedBox(height: 4),
                  Text('NIM: 1204120001', style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF1550B0))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Jenis & Target
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('JENIS TUGAS AKHIR', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                        const SizedBox(height: 8),
                        Text('Skripsi Terapan', style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF1550B0))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TARGET LUARAN', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                        const SizedBox(height: 8),
                        Text('Q1 Journal', style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF1550B0))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Tema
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TEMA TUGAS AKHIR', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  Text('Machine Learning & Big Data Analytics', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Judul
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('JUDUL TUGAS AKHIR', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  Text(
                    'Implementasi Algoritma Random Forest untuk Prediksi Kelulusan Mahasiswa Berbasis Big Data',
                    style: AppTextStyles.subtitle1.copyWith(fontWeight: FontWeight.w500, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Dosen
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF0F8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(role == 'pembimbing' ? 'DOSEN PEMBIMBING' : 'DOSEN PENGUJI', style: AppTextStyles.chipText.copyWith(color: const Color(0xFF1550B0), letterSpacing: 1.0)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: const BoxDecoration(color: Color(0xFF0F3470), shape: BoxShape.circle),
                        child: Center(child: Text('P1', style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold))),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dr. Ir. Hendra Wijaya, M.T.', style: AppTextStyles.subtitle2),
                            const SizedBox(height: 2),
                            Text(role == 'pembimbing' ? 'Pembimbing Utama' : 'Penguji Utama', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: const BoxDecoration(color: Color(0xFF475E88), shape: BoxShape.circle),
                        child: Center(child: Text('P2', style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold))),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Siti Aminah, S.Kom., M.Cs.', style: AppTextStyles.subtitle2),
                            const SizedBox(height: 2),
                            Text(role == 'pembimbing' ? 'Pembimbing Pendamping' : 'Penguji Pendamping', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Dynamic Bottom Section
            if (role == 'pembimbing') _buildPembimbingSection(),
            if (role == 'penguji') _buildPengujiSection(),
            if (role == 'lulus') _buildPengujiSection(), // Assuming similar layout for lulus
          ],
        ),
      ),
    );
  }

  Widget _buildPembimbingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('LAMA PENGERJAAN', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('142', style: AppTextStyles.heading1.copyWith(color: const Color(0xFF1550B0), fontSize: 24, height: 1.0)),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text('HARI', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PROGRESS BIMBINGAN', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('85', style: AppTextStyles.heading1.copyWith(color: const Color(0xFF1550B0), fontSize: 24, height: 1.0)),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text('%', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('DETAIL PROGRESS (BAB 1-5)', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            Text('TOTAL: 12 SESI', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        _buildProgressCard(
          no: 'No. 12',
          date: '12 Nov 2024',
          status: 'VERIFIED',
          statusColor: const Color(0xFFE6F4EA),
          statusTextColor: const Color(0xFF1A9A5B),
          title: 'Bab 3: Metodologi Penelitian',
          desc: '"Perbaiki bagian pengumpulan data primer dan instrumen penelitian."',
          fileName: 'Draft_Bab3_V2.pdf',
          verifDate: '14 Nov 2024',
        ),
        _buildProgressCard(
          no: 'No. 11',
          date: '28 Okt 2024',
          status: 'PENDING',
          statusColor: const Color(0xFFD0E2FF),
          statusTextColor: const Color(0xFF1550B0),
          title: 'Bab 2: Landasan Teori',
          desc: 'Reviewing references and citation formats in the literature review.',
          fileName: 'Reference_List.xlsx',
          verifDate: '-',
        ),
      ],
    );
  }

  Widget _buildProgressCard({
    required String no,
    required String date,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    required String title,
    required String desc,
    required String fileName,
    required String verifDate,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(12)),
                    child: Text(no, style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Text(date, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(12)),
                child: Text(status, style: AppTextStyles.caption.copyWith(color: statusTextColor, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: AppTextStyles.subtitle2),
          const SizedBox(height: 8),
          Text(desc, style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(fileName.endsWith('.pdf') ? Icons.picture_as_pdf_outlined : Icons.link, size: 16, color: const Color(0xFF1550B0)),
                  const SizedBox(width: 6),
                  Text(fileName, style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('TGL VERIFIKASI', style: AppTextStyles.caption.copyWith(color: AppColors.textHint, fontSize: 8)),
                  const SizedBox(height: 4),
                  Text(verifDate, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPengujiSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
            children: [
              Container(
                width: 32, height: 32,
                decoration: const BoxDecoration(color: Color(0xFFE8F0FE), shape: BoxShape.circle),
                child: const Center(child: Icon(Icons.assignment_turned_in_outlined, color: Color(0xFF1550B0), size: 16)),
              ),
              const SizedBox(width: 12),
              Text('VALIDASI & SIDANG', style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF1550B0), letterSpacing: 1.0)),
            ],
          ),
          const SizedBox(height: 24),
          Text('NO SK PENGUJI', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text('2024/UN10/SK/081', style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF1550B0))),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TERBIT SK', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    Text('12 Sep 2024', style: AppTextStyles.subtitle2),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TANGGAL SIDANG', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    Text('24 Okt 2024', style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFFD92D20))),
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

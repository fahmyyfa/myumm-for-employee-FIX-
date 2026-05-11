import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(title: const Text('Scan QR')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.qr_code_scanner_rounded, size: 80, color: AppColors.primary.withValues(alpha: 0.4)),
                    // Corner brackets
                    ..._buildCorners(),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text('Scan QR Code', style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              Text(
                'Arahkan kamera ke QR Code untuk\nmelakukan presensi kehadiran',
                style: AppTextStyles.bodySmall.copyWith(height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur scanner memerlukan perangkat mobile'),
                      backgroundColor: AppColors.info));
                },
                icon: const Icon(Icons.camera_alt_outlined, size: 20),
                label: const Text('Buka Scanner'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCorners() {
    const size = 30.0;
    const thickness = 3.0;
    final color = AppColors.primary;
    return [
      Positioned(top: 16, left: 16, child: _Corner(size: size, thickness: thickness, color: color, tl: true)),
      Positioned(top: 16, right: 16, child: _Corner(size: size, thickness: thickness, color: color, tr: true)),
      Positioned(bottom: 16, left: 16, child: _Corner(size: size, thickness: thickness, color: color, bl: true)),
      Positioned(bottom: 16, right: 16, child: _Corner(size: size, thickness: thickness, color: color, br: true)),
    ];
  }
}

class _Corner extends StatelessWidget {
  final double size; final double thickness; final Color color;
  final bool tl; final bool tr; final bool bl; final bool br;
  const _Corner({required this.size, required this.thickness, required this.color,
    this.tl = false, this.tr = false, this.bl = false, this.br = false});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size, height: size,
      child: CustomPaint(painter: _CornerPainter(thickness: thickness, color: color,
        tl: tl, tr: tr, bl: bl, br: br)),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final double thickness; final Color color;
  final bool tl, tr, bl, br;
  _CornerPainter({required this.thickness, required this.color,
    required this.tl, required this.tr, required this.bl, required this.br});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = thickness..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    if (tl) {
      canvas.drawLine(Offset(0, size.height * 0.4), const Offset(0, 0), paint);
      canvas.drawLine(const Offset(0, 0), Offset(size.width * 0.4, 0), paint);
    }
    if (tr) {
      canvas.drawLine(Offset(size.width * 0.6, 0), Offset(size.width, 0), paint);
      canvas.drawLine(Offset(size.width, 0), Offset(size.width, size.height * 0.4), paint);
    }
    if (bl) {
      canvas.drawLine(Offset(0, size.height * 0.6), Offset(0, size.height), paint);
      canvas.drawLine(Offset(0, size.height), Offset(size.width * 0.4, size.height), paint);
    }
    if (br) {
      canvas.drawLine(Offset(size.width * 0.6, size.height), Offset(size.width, size.height), paint);
      canvas.drawLine(Offset(size.width, size.height * 0.6), Offset(size.width, size.height), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

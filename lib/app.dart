import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_colors.dart';
import 'routing/app_router.dart';

class MyUMMApp extends ConsumerWidget {
  const MyUMMApp({super.key});

  bool get _isDesktop =>
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    final app = MaterialApp.router(
      title: 'MyUMM For Employee',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );

    // On desktop, wrap in a mobile-sized frame for development
    if (_isDesktop) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyUMM For Employee',
        theme: ThemeData.dark(),
        home: Scaffold(
          backgroundColor: const Color(0xFF1A1A2E),
          body: Center(
            child: Container(
              width: 390,
              height: 844,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 40,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: MediaQuery(
                  data: const MediaQueryData(
                    size: Size(390, 844),
                    padding: EdgeInsets.only(top: 44, bottom: 34),
                  ),
                  child: app,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return app;
  }
}

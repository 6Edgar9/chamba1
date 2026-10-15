import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chamba/core/theme/app_theme.dart';
import 'package:chamba/presentation/state/app_state.dart';
import 'package:chamba/presentation/screens/welcome_screen.dart';
import 'package:chamba/presentation/screens/login_screen.dart';
import 'package:chamba/presentation/screens/register_screen.dart';
import 'package:chamba/presentation/screens/role_selection_screen.dart';
import 'package:chamba/presentation/screens/client_shell.dart';
import 'package:chamba/presentation/screens/worker_shell.dart';
import 'package:chamba/presentation/screens/worker_wallet_screen.dart';
import 'package:chamba/presentation/screens/worker_my_jobs_screen.dart';

void main() {
  const targetResolutions = [
    Size(320, 568), // Compacto
    Size(360, 640), // Pequeño
    Size(393, 852), // Mediano (Pixel 7 / Medium Phone)
    Size(412, 915), // Grande
    Size(430, 932), // Grande Ancho
  ];

  Widget buildTestApp({
    required Widget child,
    required Size size,
    double textScale = 1.0,
  }) {
    return MediaQuery(
      data: MediaQueryData(
        size: size,
        textScaler: TextScaler.linear(textScale),
        viewInsets: EdgeInsets.zero,
        padding: const EdgeInsets.only(top: 24, bottom: 16),
      ),
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: child,
      ),
    );
  }

  group('CHAMBA Responsive Layout & No-Overflow Verification', () {
    for (final size in targetResolutions) {
      testWidgets('Auth Flow (Welcome, Login, Register, RoleSelection) renders without overflow on ${size.width}x${size.height}', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final appState = AppState();

        // 1. Welcome Screen
        await tester.pumpWidget(buildTestApp(child: WelcomeScreen(appState: appState), size: size));
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(find.text('CHAMBA'), findsOneWidget);

        // 2. Login Screen
        await tester.pumpWidget(buildTestApp(child: LoginScreen(appState: appState), size: size));
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(find.text('Iniciar Sesión'), findsWidgets);

        // 3. Register Screen
        await tester.pumpWidget(buildTestApp(child: RegisterScreen(appState: appState), size: size));
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(find.text('Crea tu cuenta CHAMBA'), findsOneWidget);

        // 4. Role Selection Screen
        await tester.pumpWidget(buildTestApp(child: RoleSelectionScreen(appState: appState), size: size));
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(find.text('¿Cómo quieres usar CHAMBA hoy?'), findsOneWidget);
      });

      testWidgets('Client & Worker Shells render without overflow on ${size.width}x${size.height}', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final appState = AppState();

        // ClientShell
        await tester.pumpWidget(buildTestApp(child: ClientShell(appState: appState), size: size));
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(find.text('Inicio'), findsOneWidget);

        // WorkerShell
        appState.switchRole(UserRole.worker);
        await tester.pumpWidget(buildTestApp(child: WorkerShell(appState: appState), size: size));
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(find.text('Chambas'), findsWidgets);
      });
    }

    testWidgets('Accessibility Text Scaling 1.3x and 1.5x does not cause RenderFlex overflow on Compact 320x568', (tester) async {
      const compactSize = Size(320, 568);
      tester.view.physicalSize = compactSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final appState = AppState();

      // Test 1.3x Scale
      await tester.pumpWidget(buildTestApp(child: WelcomeScreen(appState: appState), size: compactSize, textScale: 1.3));
      await tester.pump();
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(buildTestApp(child: LoginScreen(appState: appState), size: compactSize, textScale: 1.3));
      await tester.pump();
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(buildTestApp(child: RoleSelectionScreen(appState: appState), size: compactSize, textScale: 1.3));
      await tester.pump();
      expect(tester.takeException(), isNull);

      // Test 1.5x Scale on WorkerWalletScreen & WorkerMyJobsScreen
      await tester.pumpWidget(buildTestApp(child: WorkerWalletScreen(appState: appState), size: compactSize, textScale: 1.5));
      await tester.pump();
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(buildTestApp(child: WorkerMyJobsScreen(appState: appState), size: compactSize, textScale: 1.5));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Keyboard Open State (viewInsets.bottom: 280) in LoginScreen renders without overflow', (tester) async {
      const smallSize = Size(360, 640);
      tester.view.physicalSize = smallSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final appState = AppState();

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: smallSize,
            textScaler: TextScaler.linear(1.0),
            viewInsets: EdgeInsets.only(bottom: 280),
          ),
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: LoginScreen(appState: appState),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chamba/presentation/screens/client_shell.dart';
import 'package:chamba/presentation/screens/worker_shell.dart';
import 'package:chamba/presentation/state/app_state.dart';
import 'package:chamba/core/theme/app_theme.dart';

void main() {
  group('Shells Navigation Tests', () {
    testWidgets('ClientShell renders all 4 tabs and switches between them', (tester) async {
      final appState = AppState();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ClientShell(appState: appState),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Check BottomNavigationBar items
      expect(find.text('Inicio'), findsOneWidget);
      expect(find.text('Solicitudes'), findsOneWidget);
      expect(find.text('Mensajes'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);

      // Tap on Solicitudes tab
      await tester.tap(find.text('Solicitudes'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Mis Solicitudes'), findsOneWidget);

      // Tap on Mensajes tab
      await tester.tap(find.text('Mensajes').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Mensajes'), findsWidgets);

      // Tap on Perfil tab
      await tester.tap(find.text('Perfil'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Mi Perfil'), findsOneWidget);
      expect(find.text('Lucía Fernández'), findsOneWidget);
    });

    testWidgets('WorkerShell renders all 4 tabs and switches between them', (tester) async {
      final appState = AppState();
      appState.switchRole(UserRole.worker);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: WorkerShell(appState: appState),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Check Worker BottomNavigationBar items
      expect(find.text('Chambas'), findsOneWidget);
      expect(find.text('Mis Trabajos'), findsOneWidget);
      expect(find.text('Mensajes'), findsOneWidget);
      expect(find.text('Mi Perfil'), findsOneWidget);

      // Tap on Mis Trabajos tab
      await tester.tap(find.text('Mis Trabajos'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Mis Trabajos'), findsWidgets);

      // Tap on Mi Perfil tab
      await tester.tap(find.text('Mi Perfil'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Mi Perfil de Chambeador'), findsOneWidget);
    });
  });
}

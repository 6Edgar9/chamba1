import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chamba/data/models/user_account.dart';
import 'package:chamba/presentation/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (MethodCall methodCall) async {
        return null;
      },
    );
  });

  group('UserAccount & Unified Identity Tests', () {
    test('UserAccount creates properly and computes initials', () {
      const user = UserAccount(
        id: 'usr-123',
        fullName: 'Carlos Ramírez',
        email: 'carlos@chamba.pe',
        phone: '+51 974 555 303',
        district: 'Pimentel, Chiclayo',
      );

      expect(user.avatarInitials, equals('CR'));
      expect(user.fullName, equals('Carlos Ramírez'));
      expect(user.hasWorkerProfile, isFalse);

      final json = user.toJson();
      final fromJson = UserAccount.fromJson(json);
      expect(fromJson.id, equals('usr-123'));
      expect(fromJson.email, equals('carlos@chamba.pe'));
      expect(fromJson.avatarInitials, equals('CR'));
    });

    test('AppState maintains same identity across Client and Worker roles', () async {
      final appState = AppState();

      const user = UserAccount(
        id: 'usr-carlos-1',
        fullName: 'Carlos Ramírez',
        email: 'carlos@chamba.pe',
        phone: '+51 974 555 303',
        district: 'Pimentel, Chiclayo',
        workerProfile: WorkerProfileData(
          id: 'wp-carlos-1',
          bio: 'Gasfitero matriculado experto en bombas de agua.',
          specialty: 'Gasfitería',
          district: 'Pimentel, Chiclayo',
          rating: 4.8,
          completedJobs: 42,
        ),
      );

      // Set authenticated session
      await appState.setSession(user, 'dummy_jwt_token_abc');

      expect(appState.isAuthenticated, isTrue);

      // In Client mode:
      appState.switchRole(UserRole.client);
      expect(appState.isClient, isTrue);
      expect(appState.clientName, equals('Carlos Ramírez'));
      expect(appState.clientEmail, equals('carlos@chamba.pe'));
      expect(appState.userInitials, equals('CR'));

      // Switch to Worker mode:
      appState.switchRole(UserRole.worker);
      expect(appState.isWorker, isTrue);
      expect(appState.currentWorkerProfile.name, equals('Carlos Ramírez'));
      expect(appState.currentWorkerProfile.avatarInitials, equals('CR'));
      expect(appState.currentWorkerProfile.district, equals('Pimentel, Chiclayo'));
      expect(appState.currentWorkerProfile.skills, contains('Gasfitería'));

      // Toggle back to Client mode:
      appState.toggleUserRole();
      expect(appState.isClient, isTrue);
      expect(appState.clientName, equals('Carlos Ramírez'));
      expect(appState.clientEmail, equals('carlos@chamba.pe'));

      // Logout resets identity
      await appState.logout();
      expect(appState.isAuthenticated, isFalse);
    });
  });
}

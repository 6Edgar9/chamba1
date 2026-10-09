import 'package:flutter_test/flutter_test.dart';
import 'package:chamba/presentation/state/app_state.dart';
import 'package:chamba/data/models/job_request.dart';
import 'package:chamba/data/models/bid.dart';

void main() {
  group('AppState tests', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
    });

    test('initial state has default client role and preloaded jobs', () {
      expect(appState.currentRole, equals(UserRole.client));
      expect(appState.jobs.isNotEmpty, isTrue);
      expect(appState.workers.isNotEmpty, isTrue);
    });

    test('switchRole toggles role properly', () {
      appState.switchRole(UserRole.worker);
      expect(appState.isWorker, isTrue);
      expect(appState.isClient, isFalse);
    });

    test('createJobRequest adds job and sets it as active', () {
      final job = appState.createJobRequest(
        title: 'Reparación de chapa',
        categoryId: 'cerrajeria',
        categoryName: 'Cerrajería',
        description: 'La llave no gira',
        budget: 45.0,
        district: 'Chiclayo',
        address: 'Calle Real 123',
        urgency: 'Urgente (Hoy)',
      );

      expect(appState.jobs.first.id, equals(job.id));
      expect(appState.activeJob?.id, equals(job.id));
      expect(appState.activeJob?.budget, equals(45.0));
      expect(appState.activeJob?.status, equals(JobStatus.searching));
    });

    test('counterBid updates bid status and creates negotiation message', () {
      final initialJob = appState.jobs.first;
      final initialBid = initialJob.bids.first;

      appState.counterBid(
        jobId: initialJob.id,
        bidId: initialBid.id,
        counterAmount: 70.0,
      );

      final updatedJob = appState.jobs.firstWhere((j) => j.id == initialJob.id);
      final updatedBid = updatedJob.bids.firstWhere((b) => b.id == initialBid.id);

      expect(updatedBid.counterAmount, equals(70.0));
      expect(updatedBid.status, equals(BidStatus.countered));
    });

    test('acceptBid transitions job to onTheWay and updates accepted worker', () {
      final initialJob = appState.jobs.first;
      final targetBid = initialJob.bids.first;

      appState.acceptBid(
        jobId: initialJob.id,
        bidId: targetBid.id,
      );

      final updatedJob = appState.jobs.firstWhere((j) => j.id == initialJob.id);
      expect(updatedJob.status, equals(JobStatus.onTheWay));
      expect(updatedJob.acceptedBidId, equals(targetBid.id));
      expect(updatedJob.workerId, equals(targetBid.workerId));
    });
  });
}

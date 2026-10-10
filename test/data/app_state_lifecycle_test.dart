import 'package:flutter_test/flutter_test.dart';
import 'package:chamba/presentation/state/app_state.dart';
import 'package:chamba/data/models/job_request.dart';
import 'package:chamba/data/models/bid.dart';

void main() {
  group('AppState inDrive Lifecycle Tests', () {
    late AppState state;

    setUp(() {
      state = AppState();
    });

    test('Full lifecycle: create job -> receive bids -> counter -> accept -> arrival -> complete -> pay -> rate', () {
      // 1. Client creates job with coordinates and reference
      final job = state.createJobRequest(
        title: 'Instalación de terma solar en techo',
        categoryId: 'gasfiteria',
        categoryName: 'Gasfitería',
        description: 'Terma de 150 litros en azotea de 3er piso.',
        budget: 120.0,
        district: 'Santa Victoria, Chiclayo',
        address: 'Av. Bolognesi 450',
        urgency: 'Urgente (Hoy)',
        latitude: -6.7760,
        longitude: -79.8436,
        reference: 'Edificio Los Sauces, timbre 301',
      );

      expect(job.status, JobStatus.searching);
      expect(job.latitude, -6.7760);
      expect(job.reference, contains('Sauces'));
      expect(state.jobs.first.id, job.id);

      // 2. Worker submits bid
      state.switchRole(UserRole.worker);
      state.submitBid(
        jobId: job.id,
        amount: 140.0,
        etaMinutes: 30,
        message: 'Llego con ayudante y herramientas completas.',
      );

      final updatedJob = state.jobs.firstWhere((j) => j.id == job.id);
      expect(updatedJob.status, JobStatus.negotiating);
      expect(updatedJob.bids.length, 1);
      final firstBid = updatedJob.bids.first;
      expect(firstBid.amount, 140.0);

      // 3. Client counters bid to S/. 130
      state.switchRole(UserRole.client);
      state.counterBid(
        jobId: job.id,
        bidId: firstBid.id,
        counterAmount: 130.0,
      );

      final counteredJob = state.jobs.firstWhere((j) => j.id == job.id);
      expect(counteredJob.bids.first.counterAmount, 130.0);
      expect(counteredJob.bids.first.status, BidStatus.countered);

      // 4. Client accepts the deal
      state.acceptBid(jobId: job.id, bidId: firstBid.id);
      final acceptedJob = state.jobs.firstWhere((j) => j.id == job.id);
      expect(acceptedJob.status, JobStatus.onTheWay);
      expect(acceptedJob.budget, 130.0);
      expect(acceptedJob.workerName, isNotNull);

      // 5. Worker arrives at the house
      state.confirmArrival(job.id);
      final arrivedJob = state.jobs.firstWhere((j) => j.id == job.id);
      expect(arrivedJob.status, JobStatus.inProgress);

      // 6. Complete job
      state.completeJob(job.id);
      final completedJob = state.jobs.firstWhere((j) => j.id == job.id);
      expect(completedJob.status, JobStatus.completed);

      // 7. Register payment
      state.registerPayment(jobId: job.id, paymentMethod: 'Yape');
      final paidJob = state.jobs.firstWhere((j) => j.id == job.id);
      expect(paidJob.isPaid, isTrue);
      expect(paidJob.paymentMethod, 'Yape');

      // 8. Rate job
      state.rateJob(jobId: job.id, rating: 5, reviewComment: 'Excelente trabajo, muy profesional.');
      final ratedJob = state.jobs.firstWhere((j) => j.id == job.id);
      expect(ratedJob.rating, 5);
      expect(ratedJob.reviewComment, contains('profesional'));
    });

    test('Cancellation and bid rejection flows work accurately', () {
      final job = state.createJobRequest(
        title: 'Copia de llave Cantol',
        categoryId: 'cerrajeria',
        categoryName: 'Cerrajería',
        description: 'Duplicado de llave de seguridad',
        budget: 35.0,
        district: 'Chiclayo Centro',
        address: 'Calle Elías Aguirre 200',
        urgency: 'Flexible',
      );

      state.submitBid(
        jobId: job.id,
        amount: 50.0,
        etaMinutes: 45,
        message: 'Tengo máquinas para duplicado in situ',
      );

      final jobWithBid = state.jobs.firstWhere((j) => j.id == job.id);
      final bid = jobWithBid.bids.first;

      // Reject bid
      state.rejectBid(jobId: job.id, bidId: bid.id);
      final rejectedBid = state.jobs.firstWhere((j) => j.id == job.id).bids.first;
      expect(rejectedBid.status, BidStatus.rejected);

      // Cancel job
      state.cancelJob(job.id, reason: 'Ya lo solucioné');
      final cancelledJob = state.jobs.firstWhere((j) => j.id == job.id);
      expect(cancelledJob.status, JobStatus.cancelled);
    });

    test('Notification center tracks user events and allows marking read', () {
      expect(state.notifications.isNotEmpty, isTrue);
      final initialUnread = state.unreadNotificationsCount;
      expect(initialUnread, greaterThanOrEqualTo(1));

      state.markAllNotificationsAsRead();
      expect(state.unreadNotificationsCount, 0);
    });
  });
}

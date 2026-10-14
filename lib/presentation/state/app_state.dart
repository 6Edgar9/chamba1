import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/job_request.dart';
import '../../data/models/worker_profile.dart';
import '../../data/models/bid.dart';
import '../../data/models/chat_message.dart';
import '../../data/models/app_notification.dart';
import '../../data/mock/mock_data.dart';

enum UserRole {
  client,
  worker,
}

class AppState extends ChangeNotifier {
  UserRole _currentRole = UserRole.client;
  final List<JobRequest> _jobs = List.from(MockData.initialJobs);
  final List<WorkerProfile> _workers = List.from(MockData.mockWorkers);
  final List<ChatMessage> _chatMessages = List.from(MockData.initialChatMessages);
  final List<AppNotification> _notifications = [];

  late WorkerProfile _currentWorkerProfile;
  String? _activeJobId;

  // Client profile information
  String clientName = 'Lucía Fernández';
  String clientPhone = '+51 974 123 456';
  String clientEmail = 'lucia.fernandez@gmail.com';
  String clientDistrict = 'Santa Victoria, Chiclayo';
  String clientAddress = 'Calle Los Pinos 342, Dpto 201';

  AppState() {
    _currentWorkerProfile = _workers.first;
    _activeJobId = _jobs.first.id;

    // Prepopulate realistic notifications
    _notifications.addAll([
      AppNotification(
        id: 'notif-1',
        title: '¡Nueva oferta recibida!',
        body: 'Jorge Quispe ha enviado una propuesta por S/. 75 para tu solicitud de Gasfitería.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        relatedJobId: 'job-101',
        icon: Icons.local_offer_rounded,
      ),
      AppNotification(
        id: 'notif-2',
        title: 'Oferta recibida de Manuel S.',
        body: 'Manuel Santisteban aceptó tu presupuesto de S/. 60. Llega en 40 min.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        relatedJobId: 'job-101',
        icon: Icons.handyman_rounded,
      ),
      AppNotification(
        id: 'notif-3',
        title: 'Servicio completado',
        body: 'Tu servicio de Cerrajería fue marcado como completado.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
        icon: Icons.check_circle_outline,
      ),
    ]);
  }

  UserRole get currentRole => _currentRole;
  bool get isClient => _currentRole == UserRole.client;
  bool get isWorker => _currentRole == UserRole.worker;

  // Dynamic role-based design tokens
  Color get roleAccentColor => isClient ? AppColors.secondary : AppColors.workerAccent;
  Color get rolePrimaryColor => isClient ? AppColors.primary : AppColors.workerPrimary;
  Color get roleSurfaceColor => isClient ? AppColors.surfaceContainer : AppColors.workerSurfaceContainer;
  String get roleDisplayName => isClient ? 'Modo Cliente' : 'Modo Chamba (Técnico)';

  List<JobRequest> get jobs => List.unmodifiable(_jobs);
  List<WorkerProfile> get workers => List.unmodifiable(_workers);
  WorkerProfile get currentWorkerProfile => _currentWorkerProfile;
  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;

  JobRequest? get activeJob {
    if (_activeJobId == null) return null;
    return _jobs.firstWhere(
      (j) => j.id == _activeJobId,
      orElse: () => _jobs.first,
    );
  }

  List<JobRequest> get clientJobs =>
      _jobs.where((j) => j.clientId == 'client-1').toList();

  List<JobRequest> get availableWorkerJobs =>
      _jobs.where((j) => j.status == JobStatus.searching || j.status == JobStatus.negotiating).toList();

  List<JobRequest> get workerActiveJobs => _jobs
      .where((j) =>
          j.workerId == _currentWorkerProfile.id ||
          j.bids.any((b) => b.workerId == _currentWorkerProfile.id))
      .toList();

  List<ChatMessage> messagesForJob(String jobId) =>
      _chatMessages.where((m) => m.jobId == jobId).toList();

  // List of distinct jobs that have chat messages (conversations inbox)
  List<JobRequest> get conversationJobs {
    final jobIdsWithMessages = _chatMessages.map((m) => m.jobId).toSet();
    return _jobs.where((j) => jobIdsWithMessages.contains(j.id) || j.status != JobStatus.searching).toList();
  }

  void switchRole(UserRole role) {
    if (_currentRole != role) {
      _currentRole = role;
      notifyListeners();
    }
  }

  void toggleUserRole() {
    _currentRole = _currentRole == UserRole.client ? UserRole.worker : UserRole.client;
    notifyListeners();
  }

  void setActiveJob(String jobId) {
    _activeJobId = jobId;
    notifyListeners();
  }

  JobRequest createJobRequest({
    required String title,
    required String categoryId,
    required String categoryName,
    required String description,
    required double budget,
    required String district,
    required String address,
    required String urgency,
    double latitude = -6.7760,
    double longitude = -79.8436,
    String reference = '',
    bool isSos = false,
    double urgencyMultiplier = 1.0,
  }) {
    final generatedPin = '${1000 + (DateTime.now().millisecond * 9) % 9000}';
    final newJob = JobRequest(
      id: 'job-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      categoryId: categoryId,
      categoryName: categoryName,
      description: description,
      budget: budget,
      district: district,
      address: address,
      latitude: latitude,
      longitude: longitude,
      reference: reference,
      distanceKm: 1.5,
      urgency: urgency,
      status: JobStatus.searching,
      createdAt: DateTime.now(),
      clientId: 'client-1',
      clientName: clientName,
      confirmationCode: generatedPin,
      securityPin: generatedPin,
      isPinVerified: false,
      isSos: isSos,
      urgencyMultiplier: urgencyMultiplier,
      sosExpiresAt: isSos ? DateTime.now().add(const Duration(minutes: 30)) : null,
      escrowStatus: EscrowStatus.heldInEscrow, // Auto-held for demo smoothness
      bids: [],
    );

    _jobs.insert(0, newJob);
    _activeJobId = newJob.id;

    _notifications.insert(
      0,
      AppNotification(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: isSos ? '🚨 ¡Alerta SOS Activada (< 30 min)!' : '¡Solicitud publicada con éxito!',
        body: isSos
            ? 'Tu urgencia de "$title" fue enviada con máxima prioridad a especialistas en Chiclayo con llegada en < 30 min.'
            : 'Tu solicitud de "$title" está activa. Los especialistas cercanos están revisando tu presupuesto.',
        timestamp: DateTime.now(),
        relatedJobId: newJob.id,
        icon: isSos ? Icons.emergency_rounded : Icons.campaign_rounded,
      ),
    );

    notifyListeners();
    return newJob;
  }

  // Security PIN Verification (Face-to-face trust handshake)
  bool verifySecurityPin(String jobId, String enteredPin) {
    final jobIndex = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIndex == -1) return false;

    final job = _jobs[jobIndex];
    if (job.securityPin.trim() == enteredPin.trim() || job.confirmationCode.trim() == enteredPin.trim()) {
      _jobs[jobIndex] = job.copyWith(
        isPinVerified: true,
        status: JobStatus.inProgress,
      );

      _notifications.insert(
        0,
        AppNotification(
          id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
          title: '🛡️ ¡PIN de Seguridad Validado!',
          body: 'Identidad presencial confirmada con éxito. El servicio ha iniciado de manera segura.',
          timestamp: DateTime.now(),
          relatedJobId: jobId,
          icon: Icons.verified_user_rounded,
        ),
      );

      notifyListeners();
      return true;
    }
    return false;
  }

  // Escrow Phase 1: Deposit funds into protected guarantee
  void depositEscrow({
    required String jobId,
    required String paymentMethod,
  }) {
    final jobIndex = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIndex == -1) return;

    final job = _jobs[jobIndex];
    _jobs[jobIndex] = job.copyWith(
      escrowStatus: EscrowStatus.heldInEscrow,
      paymentMethod: paymentMethod,
    );

    _notifications.insert(
      0,
      AppNotification(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: '🔒 Pago en Garantía Protegido',
        body: 'S/. ${job.budget.toStringAsFixed(0)} depositados en custodia Chamba vía $paymentMethod. Los fondos solo se liberarán cuando apruebes el trabajo.',
        timestamp: DateTime.now(),
        relatedJobId: jobId,
        icon: Icons.shield_rounded,
      ),
    );

    notifyListeners();
  }

  // Escrow Phase 3: Upload Before Evidence
  void uploadBeforeEvidence({
    required String jobId,
    required String tag,
  }) {
    final jobIndex = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIndex == -1) return;

    final job = _jobs[jobIndex];
    _jobs[jobIndex] = job.copyWith(
      beforePhotoTag: tag,
      escrowStatus: EscrowStatus.beforePhotoUploaded,
    );

    _notifications.insert(
      0,
      AppNotification(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: '📸 Evidencia del "Antes" Registrada',
        body: 'El estado inicial del desperfecto fue capturado y archivado en tu expediente de garantía.',
        timestamp: DateTime.now(),
        relatedJobId: jobId,
        icon: Icons.camera_alt_rounded,
      ),
    );

    notifyListeners();
  }

  // Escrow Phase 4: Upload After Evidence
  void uploadAfterEvidence({
    required String jobId,
    required String tag,
  }) {
    final jobIndex = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIndex == -1) return;

    final job = _jobs[jobIndex];
    _jobs[jobIndex] = job.copyWith(
      afterPhotoTag: tag,
      escrowStatus: EscrowStatus.afterPhotoUploaded,
    );

    _notifications.insert(
      0,
      AppNotification(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: '✨ Trabajo Concluido - Evidencia "Después"',
        body: 'El técnico finalizó la intervención. Revisa las fotos y confirma la conformidad para liberar el pago.',
        timestamp: DateTime.now(),
        relatedJobId: jobId,
        icon: Icons.check_circle_rounded,
      ),
    );

    notifyListeners();
  }

  // Escrow Final: Client approves conformity and releases payment
  void releaseEscrow(String jobId) {
    final jobIndex = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIndex == -1) return;

    final job = _jobs[jobIndex];
    _jobs[jobIndex] = job.copyWith(
      escrowStatus: EscrowStatus.released,
      status: JobStatus.completed,
      isPaid: true,
    );

    _notifications.insert(
      0,
      AppNotification(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: '🎉 ¡Pago Liberado al Especialista!',
        body: 'Se transfirieron S/. ${job.budget.toStringAsFixed(0)} a ${job.workerName ?? "el especialista"}. ¡Tu garantía Chamba de 7 días está activa!',
        timestamp: DateTime.now(),
        relatedJobId: jobId,
        icon: Icons.monetization_on_rounded,
      ),
    );

    notifyListeners();
  }

  void cancelJob(String jobId, {String? reason}) {
    final jobIndex = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIndex == -1) return;

    final job = _jobs[jobIndex];
    _jobs[jobIndex] = job.copyWith(status: JobStatus.cancelled);

    _notifications.insert(
      0,
      AppNotification(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Solicitud cancelada',
        body: 'Has cancelado la solicitud "${job.title}".',
        timestamp: DateTime.now(),
        relatedJobId: jobId,
        icon: Icons.cancel_outlined,
      ),
    );

    notifyListeners();
  }

  void submitBid({
    required String jobId,
    required double amount,
    required int etaMinutes,
    required String message,
    bool hasVoiceNote = false,
    int voiceDurationSeconds = 0,
    String? voiceTranscriptPreview,
    bool includesMaterials = false,
    String estimatedArrival = '25 min',
    List<String> inclusionTags = const [],
  }) {
    final jobIndex = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIndex == -1) return;

    final newBid = Bid(
      id: 'bid-${DateTime.now().millisecondsSinceEpoch}',
      jobId: jobId,
      workerId: _currentWorkerProfile.id,
      workerName: _currentWorkerProfile.name,
      workerAvatar: _currentWorkerProfile.avatarInitials,
      workerRating: _currentWorkerProfile.rating,
      workerCompletedJobs: _currentWorkerProfile.completedJobs,
      isWorkerVerified: _currentWorkerProfile.isVerified,
      amount: amount,
      etaMinutes: etaMinutes,
      message: message,
      status: BidStatus.pending,
      createdAt: DateTime.now(),
      hasVoiceNote: hasVoiceNote,
      voiceDurationSeconds: voiceDurationSeconds,
      voiceTranscriptPreview: voiceTranscriptPreview,
      includesMaterials: includesMaterials,
      estimatedArrival: estimatedArrival,
      inclusionTags: inclusionTags,
    );

    final job = _jobs[jobIndex];
    final updatedBids = List<Bid>.from(job.bids)..add(newBid);

    _jobs[jobIndex] = job.copyWith(
      bids: updatedBids,
      status: JobStatus.negotiating,
    );

    _notifications.insert(
      0,
      AppNotification(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: '¡Oferta enviada!',
        body: 'Enviaste tu propuesta de S/. ${amount.toStringAsFixed(0)} para "${job.title}".',
        timestamp: DateTime.now(),
        relatedJobId: jobId,
        icon: Icons.send_rounded,
      ),
    );

    notifyListeners();
  }

  void counterBid({
    required String jobId,
    required String bidId,
    required double counterAmount,
  }) {
    final jobIndex = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIndex == -1) return;

    final job = _jobs[jobIndex];
    final bidIndex = job.bids.indexWhere((b) => b.id == bidId);
    if (bidIndex == -1) return;

    final updatedBid = job.bids[bidIndex].copyWith(
      counterAmount: counterAmount,
      status: BidStatus.countered,
    );

    final updatedBids = List<Bid>.from(job.bids)..[bidIndex] = updatedBid;
    _jobs[jobIndex] = job.copyWith(bids: updatedBids);

    // Record in chat messages
    _chatMessages.add(
      ChatMessage(
        id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
        jobId: jobId,
        senderId: 'client-1',
        senderName: clientName,
        isFromWorker: false,
        text: 'He enviado una contraoferta por S/. ${counterAmount.toStringAsFixed(0)}',
        proposalAmount: counterAmount,
        timestamp: DateTime.now(),
      ),
    );

    _notifications.insert(
      0,
      AppNotification(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Contraoferta enviada',
        body: 'Propusiste S/. ${counterAmount.toStringAsFixed(0)} a ${job.bids[bidIndex].workerName}.',
        timestamp: DateTime.now(),
        relatedJobId: jobId,
        icon: Icons.sync_alt_rounded,
      ),
    );

    notifyListeners();
  }

  void rejectBid({
    required String jobId,
    required String bidId,
  }) {
    final jobIndex = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIndex == -1) return;

    final job = _jobs[jobIndex];
    final bidIndex = job.bids.indexWhere((b) => b.id == bidId);
    if (bidIndex == -1) return;

    final rejectedBid = job.bids[bidIndex].copyWith(status: BidStatus.rejected);
    final updatedBids = List<Bid>.from(job.bids)..[bidIndex] = rejectedBid;

    _jobs[jobIndex] = job.copyWith(bids: updatedBids);
    notifyListeners();
  }

  void acceptBid({
    required String jobId,
    required String bidId,
  }) {
    final jobIndex = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIndex == -1) return;

    final job = _jobs[jobIndex];
    final bidIndex = job.bids.indexWhere((b) => b.id == bidId);
    if (bidIndex == -1) return;

    final acceptedBid = job.bids[bidIndex];
    final updatedBid = acceptedBid.copyWith(status: BidStatus.accepted);
    final updatedBids = List<Bid>.from(job.bids)..[bidIndex] = updatedBid;

    final agreedPrice = acceptedBid.counterAmount ?? acceptedBid.amount;

    _jobs[jobIndex] = job.copyWith(
      status: JobStatus.onTheWay,
      acceptedBidId: bidId,
      workerId: acceptedBid.workerId,
      workerName: acceptedBid.workerName,
      budget: agreedPrice,
      bids: updatedBids,
    );

    _activeJobId = jobId;

    // Send agreement message to chat
    _chatMessages.add(
      ChatMessage(
        id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
        jobId: jobId,
        senderId: 'client-1',
        senderName: clientName,
        isFromWorker: false,
        text: '¡Trato cerrado por S/. ${agreedPrice.toStringAsFixed(0)}! Código de seguridad generado.',
        proposalAmount: agreedPrice,
        timestamp: DateTime.now(),
      ),
    );

    _notifications.insert(
      0,
      AppNotification(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: '¡Especialista contratado!',
        body: '${acceptedBid.workerName} aceptó el servicio por S/. ${agreedPrice.toStringAsFixed(0)} y va en camino.',
        timestamp: DateTime.now(),
        relatedJobId: jobId,
        icon: Icons.two_wheeler_rounded,
      ),
    );

    notifyListeners();
  }

  void confirmArrival(String jobId) {
    final jobIndex = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIndex == -1) return;

    _jobs[jobIndex] = _jobs[jobIndex].copyWith(status: JobStatus.inProgress);

    _notifications.insert(
      0,
      AppNotification(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: '¡Especialista en el domicilio!',
        body: 'El especialista ha llegado y el trabajo ha iniciado.',
        timestamp: DateTime.now(),
        relatedJobId: jobId,
        icon: Icons.handyman_rounded,
      ),
    );

    notifyListeners();
  }

  void completeJob(String jobId) {
    final jobIndex = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIndex == -1) return;

    _jobs[jobIndex] = _jobs[jobIndex].copyWith(status: JobStatus.completed);

    _notifications.insert(
      0,
      AppNotification(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: '¡Chamba Finalizada!',
        body: 'El trabajo fue completado con éxito. Por favor confirma tu método de pago.',
        timestamp: DateTime.now(),
        relatedJobId: jobId,
        icon: Icons.check_circle_rounded,
      ),
    );

    notifyListeners();
  }

  void registerPayment({
    required String jobId,
    required String paymentMethod,
  }) {
    final jobIndex = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIndex == -1) return;

    _jobs[jobIndex] = _jobs[jobIndex].copyWith(
      paymentMethod: paymentMethod,
      isPaid: true,
    );

    _notifications.insert(
      0,
      AppNotification(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Pago registrado',
        body: 'Pago de S/. ${_jobs[jobIndex].budget.toStringAsFixed(0)} registrado mediante $paymentMethod.',
        timestamp: DateTime.now(),
        relatedJobId: jobId,
        icon: Icons.payments_outlined,
      ),
    );

    notifyListeners();
  }

  void rateJob({
    required String jobId,
    required int rating,
    String? reviewComment,
  }) {
    final jobIndex = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIndex == -1) return;

    _jobs[jobIndex] = _jobs[jobIndex].copyWith(
      rating: rating,
      reviewComment: reviewComment,
    );

    notifyListeners();
  }

  void updateJobStatus(String jobId, JobStatus newStatus) {
    final jobIndex = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIndex == -1) return;

    _jobs[jobIndex] = _jobs[jobIndex].copyWith(status: newStatus);
    notifyListeners();
  }

  void sendChatMessage({
    required String jobId,
    required String text,
    double? proposalAmount,
  }) {
    final isFromWorker = _currentRole == UserRole.worker;
    final senderName = isFromWorker ? _currentWorkerProfile.name : clientName;
    final senderId = isFromWorker ? _currentWorkerProfile.id : 'client-1';

    final message = ChatMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      jobId: jobId,
      senderId: senderId,
      senderName: senderName,
      isFromWorker: isFromWorker,
      text: text,
      proposalAmount: proposalAmount,
      timestamp: DateTime.now(),
    );

    _chatMessages.add(message);
    notifyListeners();
  }

  void sendInChatCounterOffer({
    required String jobId,
    required double amount,
  }) {
    final isFromWorker = _currentRole == UserRole.worker;
    final senderName = isFromWorker ? _currentWorkerProfile.name : clientName;
    final senderId = isFromWorker ? _currentWorkerProfile.id : 'client-1';

    final message = ChatMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      jobId: jobId,
      senderId: senderId,
      senderName: senderName,
      isFromWorker: isFromWorker,
      text: 'Propuesta directa en chat: S/. ${amount.toStringAsFixed(0)}',
      proposalAmount: amount,
      isCounterOffer: true,
      offerAmount: amount,
      counterOfferStatus: CounterOfferStatus.pending,
      timestamp: DateTime.now(),
    );

    _chatMessages.add(message);

    _notifications.insert(
      0,
      AppNotification(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: '💬 Nueva Contraoferta en Chat',
        body: '$senderName propuso cerrar el servicio por S/. ${amount.toStringAsFixed(0)}.',
        timestamp: DateTime.now(),
        relatedJobId: jobId,
        icon: Icons.handshake_rounded,
      ),
    );

    notifyListeners();
  }

  void acceptInChatCounterOffer({
    required String messageId,
    required String jobId,
  }) {
    final msgIndex = _chatMessages.indexWhere((m) => m.id == messageId);
    if (msgIndex == -1) return;

    final originalMsg = _chatMessages[msgIndex];
    final agreedAmount = originalMsg.offerAmount ?? originalMsg.proposalAmount ?? 50.0;

    _chatMessages[msgIndex] = originalMsg.copyWith(
      counterOfferStatus: CounterOfferStatus.accepted,
    );

    // Update job budget
    final jobIndex = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIndex != -1) {
      _jobs[jobIndex] = _jobs[jobIndex].copyWith(
        budget: agreedAmount,
      );
    }

    // Add confirmation system message to chat
    _chatMessages.add(
      ChatMessage(
        id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
        jobId: jobId,
        senderId: 'system',
        senderName: 'Chamba Oficial',
        isFromWorker: false,
        text: '🤝 ¡Trato Cerrado! Se ha fijado el precio final en S/. ${agreedAmount.toStringAsFixed(0)}.',
        proposalAmount: agreedAmount,
        timestamp: DateTime.now(),
      ),
    );

    _notifications.insert(
      0,
      AppNotification(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: '🎉 ¡Contraoferta Aceptada!',
        body: 'El precio del trabajo fue actualizado a S/. ${agreedAmount.toStringAsFixed(0)}.',
        timestamp: DateTime.now(),
        relatedJobId: jobId,
        icon: Icons.check_circle_rounded,
      ),
    );

    notifyListeners();
  }

  void rejectInChatCounterOffer({
    required String messageId,
    required String jobId,
  }) {
    final msgIndex = _chatMessages.indexWhere((m) => m.id == messageId);
    if (msgIndex == -1) return;

    final isFromWorker = _currentRole == UserRole.worker;
    final senderName = isFromWorker ? _currentWorkerProfile.name : clientName;

    _chatMessages[msgIndex] = _chatMessages[msgIndex].copyWith(
      counterOfferStatus: CounterOfferStatus.rejected,
    );

    _chatMessages.add(
      ChatMessage(
        id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
        jobId: jobId,
        senderId: isFromWorker ? _currentWorkerProfile.id : 'client-1',
        senderName: senderName,
        isFromWorker: isFromWorker,
        text: 'La propuesta de precio no fue aceptada. Puedes enviar otra oferta.',
        timestamp: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  void updateWorkerProfile(WorkerProfile profile) {
    _currentWorkerProfile = profile;
    final index = _workers.indexWhere((w) => w.id == profile.id);
    if (index != -1) {
      _workers[index] = profile;
    } else {
      _workers.add(profile);
    }
    notifyListeners();
  }

  void markAllNotificationsAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  void markNotificationAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }
}

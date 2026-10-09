import 'package:flutter/foundation.dart';
import '../../data/models/job_request.dart';
import '../../data/models/worker_profile.dart';
import '../../data/models/bid.dart';
import '../../data/models/chat_message.dart';
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
  late WorkerProfile _currentWorkerProfile;
  String? _activeJobId;

  AppState() {
    _currentWorkerProfile = _workers.first;
    _activeJobId = _jobs.first.id;
  }

  UserRole get currentRole => _currentRole;
  bool get isClient => _currentRole == UserRole.client;
  bool get isWorker => _currentRole == UserRole.worker;

  List<JobRequest> get jobs => List.unmodifiable(_jobs);
  List<WorkerProfile> get workers => List.unmodifiable(_workers);
  WorkerProfile get currentWorkerProfile => _currentWorkerProfile;

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

  void switchRole(UserRole role) {
    if (_currentRole != role) {
      _currentRole = role;
      notifyListeners();
    }
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
  }) {
    final newJob = JobRequest(
      id: 'job-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      categoryId: categoryId,
      categoryName: categoryName,
      description: description,
      budget: budget,
      district: district,
      address: address,
      distanceKm: 1.5,
      urgency: urgency,
      status: JobStatus.searching,
      createdAt: DateTime.now(),
      clientId: 'client-1',
      clientName: 'Lucía Fernández',
      confirmationCode: '${1000 + (DateTime.now().millisecond * 9) % 9000}',
      bids: [],
    );

    _jobs.insert(0, newJob);
    _activeJobId = newJob.id;
    notifyListeners();
    return newJob;
  }

  void submitBid({
    required String jobId,
    required double amount,
    required int etaMinutes,
    required String message,
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
    );

    final job = _jobs[jobIndex];
    final updatedBids = List<Bid>.from(job.bids)..add(newBid);

    _jobs[jobIndex] = job.copyWith(
      bids: updatedBids,
      status: JobStatus.negotiating,
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

    // Also add to chat history
    _chatMessages.add(
      ChatMessage(
        id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
        jobId: jobId,
        senderId: 'client-1',
        senderName: 'Lucía Fernández',
        isFromWorker: false,
        text: 'He enviado una contraoferta por S/. ${counterAmount.toStringAsFixed(0)}',
        proposalAmount: counterAmount,
        timestamp: DateTime.now(),
      ),
    );

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

    _jobs[jobIndex] = job.copyWith(
      status: JobStatus.onTheWay,
      acceptedBidId: bidId,
      workerId: acceptedBid.workerId,
      workerName: acceptedBid.workerName,
      budget: acceptedBid.counterAmount ?? acceptedBid.amount,
      bids: updatedBids,
    );

    _activeJobId = jobId;
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
    final senderName = isFromWorker ? _currentWorkerProfile.name : 'Lucía Fernández';
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
}

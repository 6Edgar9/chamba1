enum BidStatus {
  pending,
  countered,
  accepted,
  rejected,
}

class Bid {
  final String id;
  final String jobId;
  final String workerId;
  final String workerName;
  final String workerAvatar;
  final double workerRating;
  final int workerCompletedJobs;
  final bool isWorkerVerified;
  final double amount; // S/.
  final double? counterAmount; // Client or worker counter-bid
  final BidStatus status;
  final int etaMinutes;
  final String message;
  final DateTime createdAt;

  const Bid({
    required this.id,
    required this.jobId,
    required this.workerId,
    required this.workerName,
    required this.workerAvatar,
    required this.workerRating,
    required this.workerCompletedJobs,
    required this.isWorkerVerified,
    required this.amount,
    this.counterAmount,
    this.status = BidStatus.pending,
    required this.etaMinutes,
    required this.message,
    required this.createdAt,
  });

  Bid copyWith({
    double? amount,
    double? counterAmount,
    BidStatus? status,
    int? etaMinutes,
    String? message,
  }) {
    return Bid(
      id: id,
      jobId: jobId,
      workerId: workerId,
      workerName: workerName,
      workerAvatar: workerAvatar,
      workerRating: workerRating,
      workerCompletedJobs: workerCompletedJobs,
      isWorkerVerified: isWorkerVerified,
      amount: amount ?? this.amount,
      counterAmount: counterAmount ?? this.counterAmount,
      status: status ?? this.status,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      message: message ?? this.message,
      createdAt: createdAt,
    );
  }
}

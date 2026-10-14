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

  // New Phase 2 fields: Voice note & Quick Inclusion tags
  final bool hasVoiceNote;
  final int voiceDurationSeconds;
  final String? voiceTranscriptPreview;
  final bool includesMaterials;
  final String estimatedArrival;
  final List<String> inclusionTags;

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
    this.hasVoiceNote = false,
    this.voiceDurationSeconds = 0,
    this.voiceTranscriptPreview,
    this.includesMaterials = false,
    this.estimatedArrival = '25 min',
    this.inclusionTags = const [],
  });

  Bid copyWith({
    double? amount,
    double? counterAmount,
    BidStatus? status,
    int? etaMinutes,
    String? message,
    bool? hasVoiceNote,
    int? voiceDurationSeconds,
    String? voiceTranscriptPreview,
    bool? includesMaterials,
    String? estimatedArrival,
    List<String>? inclusionTags,
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
      hasVoiceNote: hasVoiceNote ?? this.hasVoiceNote,
      voiceDurationSeconds: voiceDurationSeconds ?? this.voiceDurationSeconds,
      voiceTranscriptPreview: voiceTranscriptPreview ?? this.voiceTranscriptPreview,
      includesMaterials: includesMaterials ?? this.includesMaterials,
      estimatedArrival: estimatedArrival ?? this.estimatedArrival,
      inclusionTags: inclusionTags ?? this.inclusionTags,
    );
  }
}

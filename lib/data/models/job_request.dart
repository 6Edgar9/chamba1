import 'bid.dart';

enum JobStatus {
  searching,
  negotiating,
  onTheWay,
  inProgress,
  completed,
  cancelled,
}

enum EscrowStatus {
  pendingDeposit,
  heldInEscrow,
  beforePhotoUploaded,
  afterPhotoUploaded,
  released,
}

extension EscrowStatusExtension on EscrowStatus {
  String get displayLabel {
    switch (this) {
      case EscrowStatus.pendingDeposit:
        return 'Pendiente de Depósito';
      case EscrowStatus.heldInEscrow:
        return 'Pago Protegido en Garantía';
      case EscrowStatus.beforePhotoUploaded:
        return 'Evidencia Inicial Registrada';
      case EscrowStatus.afterPhotoUploaded:
        return 'Evidencia Final Lista para Aprobación';
      case EscrowStatus.released:
        return 'Pago Liberado al Especialista';
    }
  }
}

extension JobStatusExtension on JobStatus {
  String get displayLabel {
    switch (this) {
      case JobStatus.searching:
        return 'Buscando Técnicos';
      case JobStatus.negotiating:
        return 'Negociando Ofertas';
      case JobStatus.onTheWay:
        return 'Especialista en Camino';
      case JobStatus.inProgress:
        return 'Servicio en Progreso';
      case JobStatus.completed:
        return 'Completado';
      case JobStatus.cancelled:
        return 'Cancelado';
    }
  }
}

class JobRequest {
  final String id;
  final String title;
  final String categoryId;
  final String categoryName;
  final String description;
  final double budget; // S/.
  final String district;
  final String address;
  final double distanceKm;
  final String urgency;
  final JobStatus status;
  final DateTime createdAt;
  final String clientId;
  final String clientName;
  final String confirmationCode;
  final List<Bid> bids;
  final String? acceptedBidId;
  final String? workerId;
  final String? workerName;

  final double latitude;
  final double longitude;
  final String reference;
  final String? paymentMethod;
  final int? rating;
  final String? reviewComment;
  final bool isPaid;

  // New SOS & Security PIN & Escrow fields
  final bool isSos;
  final DateTime? sosExpiresAt;
  final double urgencyMultiplier;
  final String securityPin;
  final bool isPinVerified;
  final EscrowStatus escrowStatus;
  final String? beforePhotoTag;
  final String? afterPhotoTag;

  const JobRequest({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.budget,
    required this.district,
    required this.address,
    this.latitude = -6.7760,
    this.longitude = -79.8436,
    this.reference = '',
    required this.distanceKm,
    required this.urgency,
    this.status = JobStatus.searching,
    required this.createdAt,
    required this.clientId,
    required this.clientName,
    required this.confirmationCode,
    this.bids = const [],
    this.acceptedBidId,
    this.workerId,
    this.workerName,
    this.paymentMethod,
    this.rating,
    this.reviewComment,
    this.isPaid = false,
    this.isSos = false,
    this.sosExpiresAt,
    this.urgencyMultiplier = 1.0,
    this.securityPin = '4829',
    this.isPinVerified = false,
    this.escrowStatus = EscrowStatus.pendingDeposit,
    this.beforePhotoTag,
    this.afterPhotoTag,
  });

  JobRequest copyWith({
    String? title,
    String? description,
    double? budget,
    String? district,
    String? address,
    double? latitude,
    double? longitude,
    String? reference,
    double? distanceKm,
    String? urgency,
    JobStatus? status,
    List<Bid>? bids,
    String? acceptedBidId,
    String? workerId,
    String? workerName,
    String? paymentMethod,
    int? rating,
    String? reviewComment,
    bool? isPaid,
    bool? isSos,
    DateTime? sosExpiresAt,
    double? urgencyMultiplier,
    String? securityPin,
    bool? isPinVerified,
    EscrowStatus? escrowStatus,
    String? beforePhotoTag,
    String? afterPhotoTag,
  }) {
    return JobRequest(
      id: id,
      title: title ?? this.title,
      categoryId: categoryId,
      categoryName: categoryName,
      description: description ?? this.description,
      budget: budget ?? this.budget,
      district: district ?? this.district,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      reference: reference ?? this.reference,
      distanceKm: distanceKm ?? this.distanceKm,
      urgency: urgency ?? this.urgency,
      status: status ?? this.status,
      createdAt: createdAt,
      clientId: clientId,
      clientName: clientName,
      confirmationCode: confirmationCode,
      bids: bids ?? this.bids,
      acceptedBidId: acceptedBidId ?? this.acceptedBidId,
      workerId: workerId ?? this.workerId,
      workerName: workerName ?? this.workerName,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      rating: rating ?? this.rating,
      reviewComment: reviewComment ?? this.reviewComment,
      isPaid: isPaid ?? this.isPaid,
      isSos: isSos ?? this.isSos,
      sosExpiresAt: sosExpiresAt ?? this.sosExpiresAt,
      urgencyMultiplier: urgencyMultiplier ?? this.urgencyMultiplier,
      securityPin: securityPin ?? this.securityPin,
      isPinVerified: isPinVerified ?? this.isPinVerified,
      escrowStatus: escrowStatus ?? this.escrowStatus,
      beforePhotoTag: beforePhotoTag ?? this.beforePhotoTag,
      afterPhotoTag: afterPhotoTag ?? this.afterPhotoTag,
    );
  }
}

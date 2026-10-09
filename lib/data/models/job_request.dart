import 'bid.dart';

enum JobStatus {
  searching,
  negotiating,
  onTheWay,
  inProgress,
  completed,
  cancelled,
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

  const JobRequest({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.budget,
    required this.district,
    required this.address,
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
  });

  JobRequest copyWith({
    String? title,
    String? description,
    double? budget,
    String? district,
    String? address,
    double? distanceKm,
    String? urgency,
    JobStatus? status,
    List<Bid>? bids,
    String? acceptedBidId,
    String? workerId,
    String? workerName,
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
    );
  }
}

class WorkerReview {
  final String id;
  final String clientName;
  final double rating;
  final String comment;
  final String date;

  const WorkerReview({
    required this.id,
    required this.clientName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class WorkerProfile {
  final String id;
  final String name;
  final String avatarInitials;
  final double rating;
  final int completedJobs;
  final bool isVerified;
  final List<String> skills;
  final String bio;
  final double baseRate;
  final int serviceRadiusKm;
  final String district;
  final String phone;
  final String dni;
  final int experienceYears;
  final List<WorkerReview> reviews;

  const WorkerProfile({
    required this.id,
    required this.name,
    required this.avatarInitials,
    required this.rating,
    required this.completedJobs,
    required this.isVerified,
    required this.skills,
    required this.bio,
    required this.baseRate,
    required this.serviceRadiusKm,
    required this.district,
    required this.phone,
    required this.dni,
    required this.experienceYears,
    required this.reviews,
  });

  WorkerProfile copyWith({
    String? name,
    String? avatarInitials,
    double? rating,
    int? completedJobs,
    bool? isVerified,
    List<String>? skills,
    String? bio,
    double? baseRate,
    int? serviceRadiusKm,
    String? district,
    String? phone,
    String? dni,
    int? experienceYears,
    List<WorkerReview>? reviews,
  }) {
    return WorkerProfile(
      id: id,
      name: name ?? this.name,
      avatarInitials: avatarInitials ?? this.avatarInitials,
      rating: rating ?? this.rating,
      completedJobs: completedJobs ?? this.completedJobs,
      isVerified: isVerified ?? this.isVerified,
      skills: skills ?? this.skills,
      bio: bio ?? this.bio,
      baseRate: baseRate ?? this.baseRate,
      serviceRadiusKm: serviceRadiusKm ?? this.serviceRadiusKm,
      district: district ?? this.district,
      phone: phone ?? this.phone,
      dni: dni ?? this.dni,
      experienceYears: experienceYears ?? this.experienceYears,
      reviews: reviews ?? this.reviews,
    );
  }
}

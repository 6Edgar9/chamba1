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

class BeforeAfterCase {
  final String id;
  final String title;
  final String category;
  final String beforeDescription;
  final String afterDescription;
  final String beforeImageUrl;
  final String afterImageUrl;
  final String timeSpent;
  final double cost;

  const BeforeAfterCase({
    required this.id,
    required this.title,
    required this.category,
    required this.beforeDescription,
    required this.afterDescription,
    required this.beforeImageUrl,
    required this.afterImageUrl,
    this.timeSpent = '45 min',
    this.cost = 65.0,
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

  // Escudo de Confianza flags
  final bool isIdVerified;
  final bool hasCleanRecord;
  final bool offersWarranty;

  // Real before & after work portfolio
  final List<BeforeAfterCase> portfolioCases;

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
    this.isIdVerified = true,
    this.hasCleanRecord = true,
    this.offersWarranty = true,
    this.portfolioCases = const [],
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
    bool? isIdVerified,
    bool? hasCleanRecord,
    bool? offersWarranty,
    List<BeforeAfterCase>? portfolioCases,
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
      isIdVerified: isIdVerified ?? this.isIdVerified,
      hasCleanRecord: hasCleanRecord ?? this.hasCleanRecord,
      offersWarranty: offersWarranty ?? this.offersWarranty,
      portfolioCases: portfolioCases ?? this.portfolioCases,
    );
  }
}

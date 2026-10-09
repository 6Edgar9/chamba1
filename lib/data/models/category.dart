import 'package:flutter/material.dart';

class JobCategory {
  final String id;
  final String name;
  final IconData icon;
  final String description;

  const JobCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });

  static const List<JobCategory> defaultCategories = [
    JobCategory(
      id: 'gasfiteria',
      name: 'Gasfitería',
      icon: Icons.plumbing,
      description: 'Fugas, cañerías, grifería e inodoros',
    ),
    JobCategory(
      id: 'electricidad',
      name: 'Electricidad',
      icon: Icons.electric_bolt,
      description: 'Cortocircuitos, cableado y luminarias',
    ),
    JobCategory(
      id: 'cerrajeria',
      name: 'Cerrajería',
      icon: Icons.lock_open,
      description: 'Aperturas de emergencia y chapas',
    ),
    JobCategory(
      id: 'pintura',
      name: 'Pintura',
      icon: Icons.format_paint,
      description: 'Interiores, fachadas y empastado',
    ),
    JobCategory(
      id: 'limpieza',
      name: 'Limpieza',
      icon: Icons.cleaning_services,
      description: 'Profunda para hogar y oficinas',
    ),
    JobCategory(
      id: 'carpinteria',
      name: 'Carpintería',
      icon: Icons.handyman,
      description: 'Muebles, puertas y melamine',
    ),
    JobCategory(
      id: 'albanileria',
      name: 'Albañilería',
      icon: Icons.foundation,
      description: 'Tarrajeo, pisos y refacciones',
    ),
    JobCategory(
      id: 'electrodomesticos',
      name: 'Línea Blanca',
      icon: Icons.kitchen,
      description: 'Lavadoras, refrigeradoras y hornos',
    ),
  ];
}

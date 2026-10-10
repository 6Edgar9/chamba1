import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/chamba_button.dart';
import '../../core/widgets/price_dial_stepper.dart';
import '../../data/models/category.dart';
import '../state/app_state.dart';
import '../widgets/chamba_interactive_map.dart';
import 'received_bids_screen.dart';

class PostJobScreen extends StatefulWidget {
  final AppState appState;
  final JobCategory? initialCategory;

  const PostJobScreen({
    super.key,
    required this.appState,
    this.initialCategory,
  });

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();

  late JobCategory _selectedCategory;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController(text: 'Calle Los Pinos 342, Dpto 201');
  final _districtController = TextEditingController(text: 'Santa Victoria, Chiclayo');
  final _referenceController = TextEditingController(text: 'Frente al parque principal, reja blanca');

  double _selectedLat = -6.7760;
  double _selectedLng = -79.8436;

  String _selectedUrgency = 'Urgente (Hoy)';
  double _proposedBudget = 50.0;
  bool _isPublishing = false;

  final List<String> _urgencyOptions = [
    'Urgente (Hoy)',
    'Esta semana',
    'Flexible',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? JobCategory.defaultCategories.first;
    _titleController.text = 'Reparación de ${_selectedCategory.name.toLowerCase()}';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _districtController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isPublishing = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final newJob = widget.appState.createJobRequest(
      title: _titleController.text.trim(),
      categoryId: _selectedCategory.id,
      categoryName: _selectedCategory.name,
      description: _descriptionController.text.trim().isEmpty
          ? 'Trabajo de ${_selectedCategory.name} en ${_districtController.text.trim()}'
          : _descriptionController.text.trim(),
      budget: _proposedBudget,
      district: _districtController.text.trim(),
      address: _addressController.text.trim(),
      urgency: _selectedUrgency,
      latitude: _selectedLat,
      longitude: _selectedLng,
      reference: _referenceController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isPublishing = false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ReceivedBidsScreen(
          appState: widget.appState,
          job: newJob,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Publicar Solicitud'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Detalla lo que necesitas',
                  style: AppTypography.headlineSm.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Los técnicos usarán esta información para enviarte cotizaciones exactas.',
                  style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: 20),

                // Category selector
                Text(
                  'Categoría del servicio',
                  style: AppTypography.labelLg.copyWith(color: AppColors.neutral),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: JobCategory.defaultCategories.map((cat) {
                      final isSelected = cat.id == _selectedCategory.id;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.card,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.neutral,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                          avatar: Icon(
                            cat.icon,
                            size: 16,
                            color: isSelected ? Colors.white : AppColors.primary,
                          ),
                          label: Text(cat.name),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) {
                              setState(() {
                                _selectedCategory = cat;
                                _titleController.text =
                                    'Reparación de ${cat.name.toLowerCase()}';
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Job Title
                Text(
                  'Título de la solicitud',
                  style: AppTypography.labelLg.copyWith(color: AppColors.neutral),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Ej. Fuga en lavadero de cocina',
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Ingresa un título descriptivo' : null,
                ),
                const SizedBox(height: 18),

                // Description
                Text(
                  'Descripción del trabajo',
                  style: AppTypography.labelLg.copyWith(color: AppColors.neutral),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Describe el problema, materiales requeridos o si tienes repuestos...',
                  ),
                ),
                const SizedBox(height: 20),

                // Interactive Map Section
                Text(
                  'Ubicación en el Mapa',
                  style: AppTypography.labelLg.copyWith(color: AppColors.neutral),
                ),
                const SizedBox(height: 6),
                Text(
                  'Mueve el marcador o pulsa el botón GPS para ubicar tu domicilio con precisión:',
                  style: AppTypography.labelSm.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: 10),
                ChambaInteractiveMap(
                  mode: MapDisplayMode.selectLocation,
                  height: 220,
                  initialCenter: LatLng(_selectedLat, _selectedLng),
                  onLocationChanged: (pos, name) {
                    setState(() {
                      _selectedLat = pos.latitude;
                      _selectedLng = pos.longitude;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // District & Address & Reference
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Distrito',
                            style: AppTypography.labelLg.copyWith(color: AppColors.neutral),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _districtController,
                            decoration: const InputDecoration(
                              hintText: 'Santa Victoria / Chiclayo',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dirección',
                            style: AppTypography.labelLg.copyWith(color: AppColors.neutral),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _addressController,
                            decoration: const InputDecoration(
                              hintText: 'Calle y número',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                Text(
                  'Referencia del domicilio',
                  style: AppTypography.labelLg.copyWith(color: AppColors.neutral),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _referenceController,
                  decoration: const InputDecoration(
                    hintText: 'Ej. Frente a parque, portón marrón, timbre blanco',
                    prefixIcon: Icon(Icons.near_me_outlined, size: 20),
                  ),
                ),
                const SizedBox(height: 20),

                // Urgency Chips
                Text(
                  '¿Para cuándo lo necesitas?',
                  style: AppTypography.labelLg.copyWith(color: AppColors.neutral),
                ),
                const SizedBox(height: 10),
                Row(
                  children: _urgencyOptions.map((urg) {
                    final isSelected = _selectedUrgency == urg;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        selectedColor: AppColors.surfaceContainer,
                        backgroundColor: AppColors.card,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.primary : AppColors.neutral,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        label: Text(urg),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) setState(() => _selectedUrgency = urg);
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // inDrive Style Budget Stepper Dial
                PriceDialStepper(
                  currentPrice: _proposedBudget,
                  minPrice: 15.0,
                  maxPrice: 2000.0,
                  label: 'Tu Presupuesto Inicial Ofrecido',
                  onPriceChanged: (val) {
                    setState(() => _proposedBudget = val);
                  },
                ),
                const SizedBox(height: 28),

                // Publish CTA
                ChambaButton(
                  label: _isPublishing
                      ? 'Publicando solicitud...'
                      : 'Publicar Solicitud en Chiclayo',
                  leadingIcon: Icons.send_rounded,
                  isLoading: _isPublishing,
                  onPressed: _isPublishing ? null : _submit,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

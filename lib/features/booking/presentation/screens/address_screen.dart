import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/domain/models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../core/widgets/section_card.dart';
import '../providers/booking_provider.dart';
import '../providers/municipalities_provider.dart';

/// Screen 4: Enter the service address.
class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({super.key});

  @override
  ConsumerState<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
  String? _selectedMunicipality;
  final _streetController = TextEditingController(text: 'Calle 10 #20-30');
  final _neighborhoodController = TextEditingController();
  final _instructionsController = TextEditingController();

  @override
  void dispose() {
    _streetController.dispose();
    _neighborhoodController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _selectedMunicipality != null &&
      _streetController.text.trim().isNotEmpty;

  void _continue() {
    final address = ServiceAddress(
      municipality: _selectedMunicipality!,
      street: _streetController.text.trim(),
      neighborhood: _neighborhoodController.text.trim().isEmpty
          ? null
          : _neighborhoodController.text.trim(),
      additionalInstructions: _instructionsController.text.trim().isEmpty
          ? null
          : _instructionsController.text.trim(),
    );
    ref.read(bookingProvider.notifier).setAddress(address);
    context.push('/booking/vet-list');
  }

  @override
  Widget build(BuildContext context) {
    final municipalitiesAsync = ref.watch(municipalitiesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Agendar Cita'),
      ),
      body: Column(
        children: [
          Expanded(
            child: AsyncValueWidget(
              value: municipalitiesAsync,
              data: (municipalities) {
                // Default selection on first load
                _selectedMunicipality ??=
                    municipalities.contains('Sabaneta')
                        ? 'Sabaneta'
                        : municipalities.first;

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text(
                      '¿Dónde necesitas el servicio?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SectionCard(
                      child: SecondaryButton(
                        label: '\u{1F4CD} Usar mi ubicación actual',
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        '- O -',
                        style: TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Municipio:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.border, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedMunicipality,
                          isExpanded: true,
                          items: municipalities
                              .map((m) => DropdownMenuItem(
                                    value: m,
                                    child: Text(m),
                                  ))
                              .toList(),
                          onChanged: (v) => setState(
                              () => _selectedMunicipality = v!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Dirección:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _streetController,
                      decoration: const InputDecoration(
                        hintText: 'Ej: Calle 10 #20-30',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Barrio/Sector (opcional):',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _neighborhoodController,
                      decoration: const InputDecoration(
                        hintText: 'Ej: San José',
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Indicaciones adicionales:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _instructionsController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText:
                            'Casa amarilla, timbre portón negro',
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: PrimaryButton(
              label: 'Continuar',
              onPressed: _isValid ? _continue : null,
            ),
          ),
        ],
      ),
    );
  }
}

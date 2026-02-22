import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/domain/models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../registration/presentation/providers/registration_provider.dart';

/// Screen to add a new pet from the "Mis Mascotas" tab.
class AddPetScreen extends ConsumerStatefulWidget {
  const AddPetScreen({super.key});

  @override
  ConsumerState<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends ConsumerState<AddPetScreen> {
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  Species? _selectedSpecies;
  DateTime? _nextVaccineDate;
  DateTime? _nextDewormingDate;

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty &&
      _selectedSpecies != null &&
      _breedController.text.trim().isNotEmpty &&
      _ageController.text.trim().isNotEmpty;

  Future<void> _pickDate({required bool isVaccine}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 2)),
      helpText: isVaccine
          ? 'Fecha de próxima vacuna'
          : 'Fecha de próxima desparasitación',
    );
    if (picked != null) {
      setState(() {
        if (isVaccine) {
          _nextVaccineDate = picked;
        } else {
          _nextDewormingDate = picked;
        }
      });
    }
  }

  void _addPet() {
    final pets = ref.read(registeredPetsProvider);
    final age = int.tryParse(_ageController.text.trim());
    final newPet = Pet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      species: _selectedSpecies!,
      breed: _breedController.text.trim(),
      ageYears: age,
      nextVaccineDate: _nextVaccineDate,
      nextDewormingDate: _nextDewormingDate,
    );
    ref.read(registeredPetsProvider.notifier).state = [...pets, newPet];
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Agregar Mascota'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildLabel('Nombre de la mascota *'),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Ej: Max',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('\u{1F43E}', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),
                _buildLabel('Especie *'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _SpeciesCard(
                        emoji: '\u{1F415}',
                        label: 'Perro',
                        isSelected: _selectedSpecies == Species.dog,
                        onTap: () =>
                            setState(() => _selectedSpecies = Species.dog),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SpeciesCard(
                        emoji: '\u{1F431}',
                        label: 'Gato',
                        isSelected: _selectedSpecies == Species.cat,
                        onTap: () =>
                            setState(() => _selectedSpecies = Species.cat),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildLabel('Raza *'),
                const SizedBox(height: 8),
                TextField(
                  controller: _breedController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Ej: Golden Retriever',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('\u{1F3F7}\uFE0F', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),
                _buildLabel('Edad *'),
                const SizedBox(height: 8),
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: 'Ej: 3',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('\u{1F382}', style: TextStyle(fontSize: 20)),
                    ),
                    suffixText: 'años',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),
                _buildLabel('Próxima vacuna (opcional)'),
                const SizedBox(height: 8),
                _DatePickerField(
                  value: _nextVaccineDate,
                  hint: 'Seleccionar fecha',
                  emoji: '\u{1F489}',
                  onTap: () => _pickDate(isVaccine: true),
                ),
                const SizedBox(height: 20),
                _buildLabel('Próxima desparasitación (opcional)'),
                const SizedBox(height: 8),
                _DatePickerField(
                  value: _nextDewormingDate,
                  hint: 'Seleccionar fecha',
                  emoji: '\u{1F48A}',
                  onTap: () => _pickDate(isVaccine: false),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: PrimaryButton(
              label: 'Agregar Mascota',
              onPressed: _isValid ? _addPet : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      );
}

class _SpeciesCard extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SpeciesCard({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.selectedBg : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      );
}

/// Tappable field that opens a date picker.
class _DatePickerField extends StatelessWidget {
  final DateTime? value;
  final String hint;
  final String emoji;
  final VoidCallback onTap;

  const _DatePickerField({
    required this.value,
    required this.hint,
    required this.emoji,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value != null
                      ? DateFormat('dd/MM/yyyy').format(value!)
                      : hint,
                  style: TextStyle(
                    fontSize: 15,
                    color: value != null
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
                ),
              ),
              const Icon(Icons.calendar_today, size: 18, color: AppColors.textTertiary),
            ],
          ),
        ),
      );
}

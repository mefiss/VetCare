import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/domain/models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../registration/presentation/providers/registration_provider.dart';

/// Screen to edit an existing pet's information.
class EditPetScreen extends ConsumerStatefulWidget {
  final String petId;

  const EditPetScreen({super.key, required this.petId});

  @override
  ConsumerState<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends ConsumerState<EditPetScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _breedController;
  late final TextEditingController _ageController;
  Species? _selectedSpecies;
  DateTime? _nextVaccineDate;
  DateTime? _nextDewormingDate;

  @override
  void initState() {
    super.initState();
    final pets = ref.read(registeredPetsProvider);
    final pet = pets.where((p) => p.id == widget.petId).firstOrNull;
    _nameController = TextEditingController(text: pet?.name ?? '');
    _breedController = TextEditingController(text: pet?.breed ?? '');
    _ageController = TextEditingController(
      text: pet?.ageYears?.toString() ?? '',
    );
    _selectedSpecies = pet?.species;
    _nextVaccineDate = pet?.nextVaccineDate;
    _nextDewormingDate = pet?.nextDewormingDate;
  }

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
    final current = isVaccine ? _nextVaccineDate : _nextDewormingDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? now,
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

  void _clearDate({required bool isVaccine}) {
    setState(() {
      if (isVaccine) {
        _nextVaccineDate = null;
      } else {
        _nextDewormingDate = null;
      }
    });
  }

  void _save() {
    final pets = ref.read(registeredPetsProvider);
    final index = pets.indexWhere((p) => p.id == widget.petId);
    if (index == -1) return;

    final age = int.tryParse(_ageController.text.trim());
    final updated = Pet(
      id: widget.petId,
      name: _nameController.text.trim(),
      species: _selectedSpecies!,
      breed: _breedController.text.trim(),
      ageYears: age,
      nextVaccineDate: _nextVaccineDate,
      nextDewormingDate: _nextDewormingDate,
    );

    final newList = [...pets];
    newList[index] = updated;
    ref.read(registeredPetsProvider.notifier).state = newList;
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
        title: const Text('Editar Mascota'),
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
                      child:
                          Text('\u{1F43E}', style: TextStyle(fontSize: 20)),
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
                      child: Text('\u{1F3F7}\uFE0F',
                          style: TextStyle(fontSize: 20)),
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
                      child:
                          Text('\u{1F382}', style: TextStyle(fontSize: 20)),
                    ),
                    suffixText: 'años',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),
                _buildLabel('Próxima vacuna'),
                const SizedBox(height: 8),
                _DatePickerField(
                  value: _nextVaccineDate,
                  hint: 'Seleccionar fecha',
                  emoji: '\u{1F489}',
                  onTap: () => _pickDate(isVaccine: true),
                  onClear: _nextVaccineDate != null
                      ? () => _clearDate(isVaccine: true)
                      : null,
                ),
                const SizedBox(height: 20),
                _buildLabel('Próxima desparasitación'),
                const SizedBox(height: 8),
                _DatePickerField(
                  value: _nextDewormingDate,
                  hint: 'Seleccionar fecha',
                  emoji: '\u{1F48A}',
                  onTap: () => _pickDate(isVaccine: false),
                  onClear: _nextDewormingDate != null
                      ? () => _clearDate(isVaccine: false)
                      : null,
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
              label: 'Guardar Cambios',
              onPressed: _isValid ? _save : null,
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
                  color:
                      isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      );
}

/// Tappable date field with optional clear button.
class _DatePickerField extends StatelessWidget {
  final DateTime? value;
  final String hint;
  final String emoji;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _DatePickerField({
    required this.value,
    required this.hint,
    required this.emoji,
    required this.onTap,
    this.onClear,
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
              if (onClear != null)
                GestureDetector(
                  onTap: onClear,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.close, size: 18, color: AppColors.textTertiary),
                  ),
                ),
              const Icon(Icons.calendar_today,
                  size: 18, color: AppColors.textTertiary),
            ],
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../data/mock_data.dart';
import '../providers/registration_provider.dart';

/// Registration screen for veterinarians.
class VetRegistrationScreen extends ConsumerStatefulWidget {
  const VetRegistrationScreen({super.key});

  @override
  ConsumerState<VetRegistrationScreen> createState() =>
      _VetRegistrationScreenState();
}

class _VetRegistrationScreenState
    extends ConsumerState<VetRegistrationScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedMunicipality;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty &&
      _addressController.text.trim().isNotEmpty &&
      _selectedMunicipality != null;

  void _register() {
    final vet = Vet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      coverageMunicipalities: [_selectedMunicipality!],
    );
    ref.read(registeredVetProvider.notifier).state = vet;
    context.go('/vet-home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/role-select'),
        ),
        title: const Text('Registro Veterinario'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  '\u{1FA7A} Datos del veterinario',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Completa tu informaci\u00f3n para comenzar',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 25),
                _buildLabel('Nombre completo *'),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Ej: Dr. Juan P\u00e9rez',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child:
                          Text('\u{1F464}', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),
                _buildLabel('Tel\u00e9fono *'),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: 'Ej: 3001234567',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child:
                          Text('\u{1F4F1}', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),
                _buildLabel('Direcci\u00f3n del consultorio *'),
                const SizedBox(height: 8),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    hintText: 'Ej: Calle 10 #20-30',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child:
                          Text('\u{1F3E5}', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),
                _buildLabel('Municipio *'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedMunicipality,
                      isExpanded: true,
                      hint: const Text('Selecciona tu municipio'),
                      items: MockData.municipalities
                          .map((m) => DropdownMenuItem(
                                value: m,
                                child: Text(m),
                              ))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _selectedMunicipality = v),
                    ),
                  ),
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
              label: 'Registrar Veterinario',
              onPressed: _isValid ? _register : null,
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

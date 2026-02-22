import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../data/mock_data.dart';
import '../../../registration/presentation/providers/registration_provider.dart';

/// Screen to edit the user's profile information.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _neighborhoodController;
  String? _selectedMunicipality;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
    _neighborhoodController =
        TextEditingController(text: user?.neighborhood ?? '');
    _selectedMunicipality = user?.municipality;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _neighborhoodController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty &&
      _addressController.text.trim().isNotEmpty &&
      _selectedMunicipality != null;

  void _save() {
    final updatedUser = User(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      municipality: _selectedMunicipality!,
      neighborhood: _neighborhoodController.text.trim().isEmpty
          ? null
          : _neighborhoodController.text.trim(),
    );
    ref.read(userProvider.notifier).state = updatedUser;
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
        title: const Text('Editar Perfil'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildLabel('Nombre completo *'),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Ej: Diego Pérez',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child:
                          Text('\u{1F464}', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),
                _buildLabel('Celular *'),
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
                _buildLabel('Dirección *'),
                const SizedBox(height: 8),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    hintText: 'Ej: Calle 10 #20-30',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child:
                          Text('\u{1F4CD}', style: TextStyle(fontSize: 20)),
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
                const SizedBox(height: 20),
                _buildLabel('Barrio (opcional)'),
                const SizedBox(height: 8),
                TextField(
                  controller: _neighborhoodController,
                  decoration: const InputDecoration(
                    hintText: 'Ej: San José',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('\u{1F3D8}\uFE0F',
                          style: TextStyle(fontSize: 20)),
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

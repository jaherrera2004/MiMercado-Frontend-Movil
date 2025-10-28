import 'package:flutter/material.dart';

enum UserType { usuario, repartidor }

/// Widget personalizado para seleccionar entre Usuario y Repartidor
class UserTypeSelector extends StatelessWidget {
  final UserType selectedType;
  final Function(UserType) onChanged;
  final Color primaryColor;

  const UserTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tipo de Usuario",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.grey.shade50,
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildOption(
                  type: UserType.usuario,
                  label: "Usuario",
                  icon: Icons.person,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.grey.shade300,
              ),
              Expanded(
                child: _buildOption(
                  type: UserType.repartidor,
                  label: "Repartidor",
                  icon: Icons.delivery_dining,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOption({
    required UserType type,
    required String label,
    required IconData icon,
  }) {
    final isSelected = selectedType == type;
    
    return GestureDetector(
      onTap: () => onChanged(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? primaryColor : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
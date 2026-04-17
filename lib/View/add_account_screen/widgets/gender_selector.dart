
import 'package:flutter/material.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/user_provider/user_provider.dart';
import 'package:provider/provider.dart';

class GenderSelector extends StatelessWidget {
  final String? gender;
  const GenderSelector({super.key, this.gender});

  @override
  Widget build(BuildContext context) {
    final options = ['Male', 'Female', 'Other'];
    final icons = [
      Icons.male_rounded,
      Icons.female_rounded,
      Icons.transgender_rounded,
    ];

    return Row(
      children: List.generate(options.length, (i) {
        final selected = gender == options[i];
        return Expanded(
          child: GestureDetector(
            onTap: () =>
                context.read<UserProvider>().setGender(options[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: i < options.length - 1 ? 10 : 0),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected
                      ? AppColors.primary
                      : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.30),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              child: Column(
                children: [
                  Icon(
                    icons[i],
                    size: 22,
                    color: selected ? Colors.white : AppColors.primary,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    options[i],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/user_provider/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;
    final name = user?.name ?? 'Guest';
    final email = user?.email ?? 'No email';
    final phone = user?.phoneNumber ?? '';
    final imageUrl = user?.profilePhoto ?? '';

    return Container(
      color: AppColors.primary,
      child: Stack(
        children: [
          // Decorative orbs
          Positioned(
            top: -60, right: -40,
            child: Container(
              width: 220, height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF5856D6).withOpacity(0.18),
              ),
            ),
          ),
          Positioned(
            top: 20, left: -60,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF34C759).withOpacity(0.10),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 60, 22, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text('MY PROFILE',
                    //     style: TextStyle(
                    //       fontSize: 11, fontWeight: FontWeight.w600,
                    //       letterSpacing: 0.9, color: Color(0x66FFFFFF),
                    //     )),
                    // const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 76, height: 76,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFF5856D6), Color(0xFFAF52DE)],
                                ),
                              ),
                              child: imageUrl.isEmpty
                                  ? const Icon(Icons.person, color: Colors.white, size: 36)
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Image.network(imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(Icons.person, color: Colors.white, size: 36)),
                                    ),
                            ),
                            Positioned(
                              bottom: -3, right: -3,
                              child: Container(
                                width: 16, height: 16,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF34C759),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF1C1C1E), width: 2.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: const TextStyle(
                                      fontSize: 21, fontWeight: FontWeight.w700,
                                      color: Colors.white, letterSpacing: -0.4,
                                    )),
                                const SizedBox(height: 5),
                                Row(children: [
                                  Icon(FontAwesomeIcons.at, size: 12, color: Colors.white.withOpacity(0.4)),
                                  const SizedBox(width: 5),
                                  Text(email, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.45))),
                                ]),
                                if (phone.isNotEmpty) ...[
                                  const SizedBox(height: 3),
                                  Row(children: [
                                    Icon(Icons.phone_outlined, size: 12, color: Colors.white.withOpacity(0.4)),
                                    const SizedBox(width: 5),
                                    Text(phone, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.45))),
                                  ]),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Stats row
                    // Row(
                    //   children: [
                    //     _StatChip(value: '48', label: 'Orders'),
                    //     const SizedBox(width: 10),
                    //     _StatChip(value: '12', label: 'Wishlist'),
                    //     const SizedBox(width: 10),
                    //     _StatChip(value: '4.9', label: 'Rating'),
                    //   ],
                    // ),
                  ],
                ),
              ),
              // Curved cutout into light background
              Container(
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700,
                  color: Colors.white, letterSpacing: -0.5,
                )),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                  fontSize: 11, color: Colors.white.withOpacity(0.4),
                )),
          ],
        ),
      ),
    );
  }
}
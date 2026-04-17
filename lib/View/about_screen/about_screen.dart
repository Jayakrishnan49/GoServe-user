
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_2/constants/app_color.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'About',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Hero Section ──────────────────────────────────────
            _HeroSection(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── App Info ──────────────────────────────────
                  _SectionHeader(title: 'App Info', icon: Icons.widgets_outlined),
                  const SizedBox(height: 12),
                  _ModernInfoCard(
                    rows: [
                      _RowData(Icons.info_outline_rounded, 'App Name', 'GoServe'),
                      _RowData(Icons.tag_rounded, 'Version', '1.0.0'),
                      _RowData(Icons.build_circle_outlined, 'Build', '1'),
                      _RowData(
                        Icons.phone_android_rounded,
                        'Platform',
                        Theme.of(context).platform == TargetPlatform.iOS ? 'iOS' : 'Android',
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── Developer ─────────────────────────────────
                  _SectionHeader(title: 'Developer', icon: Icons.person_outline_rounded),
                  const SizedBox(height: 12),
                  _ModernInfoCard(
                    rows: [
                      _RowData(Icons.person_outline_rounded, 'Developer', 'Jayakrishnan'),
                      _RowData(Icons.location_on_outlined, 'Location', 'Kerala, India'),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── Contact & Support ─────────────────────────
                  _SectionHeader(title: 'Contact & Support', icon: Icons.support_agent_outlined),
                  const SizedBox(height: 12),

                  _PremiumContactCard(
                    icon: Icons.email_rounded,
                    label: 'Email Us',
                    subtitle: 'supportgoserve@gmail.com',
                    gradientColors: [Color(0xFF4285F4), Color(0xFF74A9FF)],
                    onTap: () => _launchUrl('mailto:supportgoserve@gmail.com'),
                  ),
                  const SizedBox(height: 10),
                  _PremiumContactCard(
                    icon: Icons.phone_rounded,
                    label: 'Call Us',
                    subtitle: '+91 97455 73849',
                    gradientColors: [Color(0xFF34A853), Color(0xFF6FCF8A)],
                    onTap: () => _launchUrl('tel:+919745573849'),
                  ),
                  const SizedBox(height: 10),
                  _PremiumContactCard(
                    icon: FontAwesomeIcons.whatsapp,
                    label: 'WhatsApp',
                    subtitle: 'Chat with support',
                    gradientColors: [Color(0xFF25D366), Color(0xFF57EF8A)],
                    onTap: () => _launchUrl('https://wa.me/919745573849'),
                  ),

                  const SizedBox(height: 40),

                  // ── Footer ────────────────────────────────────
                  _Footer(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hero Section ─────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 48),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.85),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo with glow ring
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 108,
                height: 108,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'GS',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Text(
            'GoServe',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Your trusted service companion',
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 16),

          // Description with glass card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Text(
              'GoServe helps users easily find and book trusted local service providers for daily needs like plumbing, electrical, and home services.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.88),
                fontSize: 13,
                height: 1.55,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Version pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.rocket_launch_rounded, size: 13, color: Colors.white.withOpacity(0.85)),
                const SizedBox(width: 6),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Header ───────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: AppColors.primary),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1C1C2E),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

// ── Info Card ────────────────────────────────────────────────────

class _RowData {
  final IconData icon;
  final String label;
  final String value;
  final bool isLink;
  final VoidCallback? onTap;
  const _RowData(this.icon, this.label, this.value, {this.isLink = false, this.onTap});
}

class _ModernInfoCard extends StatelessWidget {
  final List<_RowData> rows;
  const _ModernInfoCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(rows.length, (i) {
          final row = rows[i];
          final isLast = i == rows.length - 1;
          return Column(
            children: [
              GestureDetector(
                onTap: row.onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withOpacity(0.15),
                              AppColors.primary.withOpacity(0.07),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Icon(row.icon, size: 17, color: AppColors.primary),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          row.label,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Text(
                        row.value,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: row.isLink ? AppColors.primary : const Color(0xFF1C1C2E),
                          decoration: row.isLink ? TextDecoration.underline : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Divider(height: 1, indent: 52, endIndent: 16, color: Colors.grey.shade100),
            ],
          );
        }),
      ),
    );
  }
}

// ── Premium Contact Card ─────────────────────────────────────────

class _PremiumContactCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _PremiumContactCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.12),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors[0].withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C2E),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Footer ───────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 1,
              color: Colors.grey.shade300,
            ),
            const SizedBox(width: 12),
            Text(
              'GS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.primary.withOpacity(0.5),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 1,
              color: Colors.grey.shade300,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '© ${DateTime.now().year} GoServe · All rights reserved',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade400,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Made with ♥ in Kerala, India',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}

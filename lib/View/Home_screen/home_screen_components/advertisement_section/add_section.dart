
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:project_2/constants/app_color.dart';

class _FeatureData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String tag;
  final List<Color> gradientColors;
  final Color accentColor;

  const _FeatureData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.gradientColors,
    required this.accentColor,
  });
}

const List<_FeatureData> _features = [
  _FeatureData(
    icon: Icons.handyman_rounded,
    title: 'Book Any Service',
    subtitle: 'Find trusted professionals\nnear you in seconds',
    tag: 'INSTANT BOOKING',
    gradientColors: [Color(0xFF082F46), Color(0xFF0D5C8A)],
    accentColor: Color(0xFF7EC8E3),
  ),
  // _FeatureData(
  //   icon: Icons.location_on_rounded,
  //   title: 'Real-time Tracking',
  //   subtitle: 'Know exactly where\nyour provider is',
  //   tag: 'LIVE UPDATES',
  //   gradientColors: [Color(0xFF082F46), Color(0xFF5C3A00)],
  //   accentColor: Color(0xFFFFBB33),
  // ),
  _FeatureData(
    icon: Icons.verified_rounded,
    title: 'Verified Providers',
    subtitle: 'Background-checked\nprofessionals only',
    tag: '100% TRUSTED',
    gradientColors: [Color(0xFF082F46), Color(0xFF0B4F3A)],
    accentColor: Color(0xFF43C27A),
  ),
  _FeatureData(
    icon: Icons.star_rounded,
    title: 'Rate & Review',
    subtitle: 'Your feedback shapes\nservice quality',
    tag: 'COMMUNITY DRIVEN',
    gradientColors: [Color(0xFF082F46), Color(0xFF6B1A38)],
    accentColor: Color(0xFFEB3874),
  ),
];

class AddSection extends StatelessWidget {
  AddSection({super.key});

  final ValueNotifier<int> _currentIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _features.length,
          itemBuilder: (context, index, realIndex) {
            return _CardBody(feature: _features[index]);
          },
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 600),
            autoPlayCurve: Curves.easeInOutCubic,
            enlargeCenterPage: true,
            enlargeFactor: 0.1,
            viewportFraction: 0.88,
            onPageChanged: (index, _) => _currentIndex.value = index,
          ),
        ),
        const SizedBox(height: 12),

        // Dot indicators
        ValueListenableBuilder<int>(
          valueListenable: _currentIndex,
          builder: (context, currentIndex, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_features.length, (index) {
                final isActive = index == currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 22 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: isActive
                        ? _features[currentIndex].accentColor
                        : AppColors.primary.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}

class _CardBody extends StatelessWidget {
  final _FeatureData feature;
  const _CardBody({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: feature.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: feature.gradientColors.last.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // ── Large semi-transparent icon as background ──
            Positioned(
              right: -18,
              bottom: -18,
              child: Icon(
                feature.icon,
                size: 150,
                color: Colors.white.withOpacity(0.06),
              ),
            ),

            // ── Glowing border ──
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: feature.accentColor.withOpacity(0.2),
                    width: 1.2,
                  ),
                ),
              ),
            ),

            // ── Content ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Small icon in accent circle
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: feature.accentColor.withOpacity(0.12),
                      border: Border.all(
                        color: feature.accentColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      feature.icon,
                      color: feature.accentColor,
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 18),

                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Tag
                        Text(
                          feature.tag,
                          style: TextStyle(
                            color: feature.accentColor,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.3,
                          ),
                        ),
                        const SizedBox(height: 5),

                        // Title
                        Text(
                          feature.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Subtitle
                        Text(
                          feature.subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
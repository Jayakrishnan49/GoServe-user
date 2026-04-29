import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/controllers/help_support_provider/help_support_provider.dart';
import 'package:project_2/controllers/help_support_provider/report_sheet_provider.dart';
import 'package:project_2/controllers/user_provider/user_provider.dart';
import 'package:project_2/services/submission_service.dart';
import 'package:project_2/view/help_and_support_screen/my_submission_screen.dart';
import 'package:project_2/widgets/custom_modern_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  static const List<_FaqItem> _faqs = [
    _FaqItem(
      question: 'How do I book a service?',
      answer:
          'Browse available services from the home screen, select a provider, choose your preferred time slot, and confirm your booking. You\'ll receive a confirmation notification once booked.',
    ),
    _FaqItem(
      question: 'How do I cancel a booking?',
      answer:
          'Go to My Bookings, select the booking you want to cancel, and tap "Cancel Booking". Cancellations made at least 2 hours before the scheduled time are free of charge.',
    ),
    _FaqItem(
      question: 'How are service providers verified?',
      answer:
          'All providers on GoServe go through a background check, ID verification, and skill assessment before being listed. We ensure only trusted professionals are available on the platform.',
    ),
    _FaqItem(
      question: 'What payment methods are accepted?',
      answer:
          'We accept UPI, credit/debit cards, net banking, and cash on service. All online payments are secured and encrypted.',
    ),
    _FaqItem(
      question: 'What if I\'m not satisfied with the service?',
      answer:
          'Your satisfaction is our priority. If you\'re not happy, contact support within 24 hours of service completion and we\'ll arrange a re-service or provide a refund.',
    ),
    _FaqItem(
      question: 'How do I track my service provider?',
      answer:
          'Once your booking is confirmed and the provider is on the way, you can track their live location from the booking details screen.',
    ),
  ];

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showFeedbackSheet(BuildContext context) {
    final user = context.read<UserProvider>().currentUser;
    final controller = TextEditingController();
    final isSubmitting = ValueNotifier<bool>(false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Send Feedback',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C1C2E))),
              const SizedBox(height: 4),
              Text(
                  'We read every message and use it to improve GoServe.',
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey.shade500)),
              const SizedBox(height: 18),
              TextField(
                controller: controller,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText:
                      'Share your thoughts, ideas or suggestions...',
                  hintStyle: TextStyle(
                      fontSize: 13, color: Colors.grey.shade400),
                  filled: true,
                  fillColor: const Color(0xFFF4F6FB),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<bool>(
                valueListenable: isSubmitting,
                builder: (context, submitting, _) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submitting ||
                              controller.text.trim().isEmpty
                          ? null
                          : () async {
                              if (controller.text.trim().isEmpty)
                                return;
                              isSubmitting.value = true;
                              try {
                                await SubmissionService()
                                    .submitFeedback(
                                  userName: user?.name ?? 'User',
                                  userEmail: user?.email ?? '',
                                  message: controller.text.trim(),
                                );
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  // ScaffoldMessenger.of(context)
                                  //     .showSnackBar(SnackBar(
                                  //   content: const Text(
                                  //       'Thanks for your feedback! 🙌'),
                                  //   backgroundColor: AppColors.primary,
                                  //   behavior: SnackBarBehavior.floating,
                                  //   shape: RoundedRectangleBorder(
                                  //       borderRadius:
                                  //           BorderRadius.circular(12)),
                                  // ));
                                  ModernSnackBar.show(
                                    context: context,
                                    title: 'submitted',
                                    message: 'Thanks for your feedback! 🙌',
                                    type: SnackBarType.success,
                                  );
                                }
                              } catch (e) {
                                isSubmitting.value = false;
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        foregroundColor: AppColors.secondary,
                        padding:
                            const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text('Submit Feedback',
                              style: TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w600)),
                    ),
                    
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReportSheet(BuildContext context) {
    const issues = [
      'App is crashing',
      'Payment issue',
      'Provider didn\'t show up',
      'Wrong service delivered',
      'Billing problem',
      'Other',
    ];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider(
        create: (_) => ReportSheetProvider(),
        child: _ReportSheet(issues: issues, parentContext: context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HelpSupportProvider(),
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Help & Support',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ── Banner ──────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8))
                        ],
                      ),
                      child: Icon(Icons.support_agent_rounded,
                          size: 40, color: AppColors.primary),
                    ),
                    const SizedBox(height: 14),
                    const Text('How can we help you?',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(
                        'Find answers or reach out to our support team',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13)),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Quick Actions ────────────────────────
                    const _SectionLabel(title: 'Quick Actions'),
                    const SizedBox(height: 12),
                    Builder(
                        builder: (ctx) => Row(
                              children: [
                                Expanded(
                                  child: _QuickActionCard(
                                    icon: Icons.bug_report_outlined,
                                    label: 'Report a Problem',
                                    description:
                                        'Something not working?',
                                    accentColor:
                                        const Color(0xFFFF5C5C),
                                    onTap: () =>
                                        _showReportSheet(ctx),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _QuickActionCard(
                                    icon:
                                        Icons.rate_review_outlined,
                                    label: 'Send Feedback',
                                    description:
                                        'Ideas to improve us?',
                                    accentColor:
                                        const Color(0xFF7C6EF7),
                                    onTap: () =>
                                        _showFeedbackSheet(ctx),
                                  ),
                                ),
                              ],
                            )),

                    const SizedBox(height: 16),

                    // ── My Submissions card ──────────────────
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const MySubmissionsScreen()),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color:
                                  AppColors.primary.withOpacity(0.15)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primary.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.history_rounded,
                                  color: AppColors.primary, size: 25),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'My Submissions',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Track your reports and feedback',
                                    style: TextStyle(
                                        fontSize: 12.5,
                                        color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded,
                                size: 14, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── FAQ ──────────────────────────────────
                    const _SectionLabel(
                        title: 'Frequently Asked Questions'),
                    const SizedBox(height: 12),
                    Consumer<HelpSupportProvider>(
                      builder: (context, provider, _) => Column(
                        children: List.generate(
                          _faqs.length,
                          (i) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _FaqCard(
                              faq: _faqs[i],
                              index: i,
                              isExpanded:
                                  provider.expandedIndex == i,
                              onTap: () => provider.toggleFaq(i),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Contact & Support ────────────────────
                    const _SectionLabel(title: 'Contact & Support'),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          _buildContactTile(
                            icon: Icons.email_outlined,
                            iconColor: Colors.blue,
                            label: 'Email',
                            value: 'supportgoserve@gmail.com',
                            onTap: () => _launchUrl(
                                'mailto:supportgoserve@gmail.com'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16),
                            child: Divider(
                                height: 1, color: Colors.grey[100]),
                          ),
                          _buildContactTile(
                            icon: Icons.phone_outlined,
                            iconColor: Colors.green,
                            label: 'Phone',
                            value: '+91 97455 73849',
                            onTap: () =>
                                _launchUrl('tel:+919745573849'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16),
                            child: Divider(
                                height: 1, color: Colors.grey[100]),
                          ),
                          _buildContactTile(
                            icon: FontAwesomeIcons.whatsapp,
                            iconColor: const Color(0xFF25D366),
                            label: 'WhatsApp',
                            value: 'Chat with support',
                            onTap: () => _launchUrl(
                                'https://wa.me/919745573849'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                    Center(
                      child: Text(
                        'We typically respond within 24 hours ⏱',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[400]),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey[500])),
                  const SizedBox(height: 2),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1F2937))),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 13, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  REPORT SHEET (with description field + Firestore)
// ════════════════════════════════════════════════════════════
class _ReportSheet extends StatelessWidget {
  final List<String> issues;
  final BuildContext parentContext;
  final TextEditingController descController = TextEditingController();

   _ReportSheet(
      {required this.issues, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    // final descController = TextEditingController();
    final isSubmitting = ValueNotifier<bool>(false);

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Consumer<ReportSheetProvider>(
        builder: (context, provider, _) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Report a Problem',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C1C2E))),
              const SizedBox(height: 4),
              Text('Select the issue you\'re facing.',
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey.shade500)),
              const SizedBox(height: 16),

              // Issue selector
              ...issues.map((issue) => GestureDetector(
                    onTap: () => provider.select(issue),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 13),
                      decoration: BoxDecoration(
                        color: provider.selected == issue
                            ? AppColors.primary.withOpacity(0.08)
                            : const Color(0xFFF4F6FB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: provider.selected == issue
                              ? AppColors.primary.withOpacity(0.4)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(issue,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight:
                                      provider.selected == issue
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                  color: provider.selected == issue
                                      ? AppColors.buttonColor
                                      : const Color(0xFF1C1C2E),
                                )),
                          ),
                          if (provider.selected == issue)
                            Icon(Icons.check_circle_rounded,
                                size: 18, color: AppColors.successAlert),
                        ],
                      ),
                    ),
                  )),

              // Description field
              if (provider.selected != null) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText:
                        'Describe the issue in more detail (optional)...',
                    hintStyle: TextStyle(
                        fontSize: 13, color: Colors.grey.shade400),
                    filled: true,
                    fillColor: const Color(0xFFF4F6FB),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              ValueListenableBuilder<bool>(
                valueListenable: isSubmitting,
                builder: (context, submitting, _) {
                  final user = parentContext
                      .read<UserProvider>()
                      .currentUser;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.selected == null ||
                              submitting
                          ? null
                          : () async {
                              isSubmitting.value = true;
                              try {
                                await SubmissionService()
                                    .submitReport(
                                  userName: user?.name ?? 'User',
                                  userEmail: user?.email ?? '',
                                  category: provider.selected!,
                                  description:
                                      descController.text.trim(),
                                );
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  // ScaffoldMessenger.of(parentContext)
                                  //     .showSnackBar(SnackBar(
                                  //   content: const Text(
                                  //       'Problem reported. We\'ll look into it!'),
                                  //   backgroundColor: AppColors.primary,
                                  //   behavior: SnackBarBehavior.floating,
                                  //   shape: RoundedRectangleBorder(
                                  //       borderRadius:
                                  //           BorderRadius.circular(12)),
                                  // ));
                                  ModernSnackBar.show(
                                    context: context,
                                    title: 'Submitted',
                                    message: 'Problem reported. We\'ll look into it!',
                                    type: SnackBarType.success
                                  );
                                }
                              } catch (e) {
                                isSubmitting.value = false;
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        foregroundColor: AppColors.secondary,
                        disabledBackgroundColor:
                            Colors.grey.shade200,
                        padding:
                            const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text('Submit Report',
                              style: TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w600)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Keep all existing widgets unchanged ──────────────────────────

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color accentColor;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(height: 12),
            Text(label,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937))),
            const SizedBox(height: 3),
            Text(description,
                style: TextStyle(
                    fontSize: 12.5, color: Colors.grey[500])),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('Tap here',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: accentColor)),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded,
                    size: 12, color: accentColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});
}

class _FaqCard extends StatelessWidget {
  final _FaqItem faq;
  final int index;
  final bool isExpanded;
  final VoidCallback onTap;

  const _FaqCard({
    required this.faq,
    required this.index,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isExpanded
              ? AppColors.primary.withOpacity(0.04)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isExpanded
                ? AppColors.primary.withOpacity(0.25)
                : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: isExpanded
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isExpanded
                            ? Colors.white
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    faq.question,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: isExpanded
                          ? AppColors.primary
                          : const Color(0xFF1F2937),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.keyboard_arrow_down_rounded,
                      size: 22,
                      color: isExpanded
                          ? AppColors.primary
                          : Colors.grey.shade400),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 12, left: 38),
                child: Text(faq.answer,
                    style: TextStyle(
                        fontSize: 13.5,
                        color: Colors.grey.shade600,
                        height: 1.6)),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1F2937)),
    );
  }
}
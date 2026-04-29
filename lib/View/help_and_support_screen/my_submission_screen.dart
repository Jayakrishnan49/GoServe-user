import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_2/constants/app_color.dart';
import 'package:project_2/services/submission_service.dart';

class MySubmissionsScreen extends StatelessWidget {
  const MySubmissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'My Submissions',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle:
                TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            tabs: [
              Tab(text: 'Reports'),
              Tab(text: 'Feedback'),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: SubmissionService().getUserSubmissions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.primary));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return TabBarView(
                children: [
                  _emptyState(
                      'No reports yet',
                      'Tap "Report a Problem" to submit an issue',
                      Icons.bug_report_outlined),
                  _emptyState(
                      'No feedback yet',
                      'Tap "Send Feedback" to share your thoughts',
                      Icons.rate_review_outlined),
                ],
              );
            }

            final docs = snapshot.data!.docs;
            final reports = docs
                .where((d) =>
                    (d.data() as Map<String, dynamic>)['type'] ==
                    'report')
                .toList();
            final feedbacks = docs
                .where((d) =>
                    (d.data() as Map<String, dynamic>)['type'] ==
                    'feedback')
                .toList();

            return TabBarView(
              children: [
                _ReportsList(reports: reports),
                _FeedbackList(feedbacks: feedbacks),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _emptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937))),
            const SizedBox(height: 6),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  REPORTS LIST
// ════════════════════════════════════════════════════════════
class _ReportsList extends StatelessWidget {
  final List<QueryDocumentSnapshot> reports;

  const _ReportsList({required this.reports});

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bug_report_outlined,
                size: 56, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('No reports yet',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937))),
            const SizedBox(height: 6),
            Text('Your submitted reports will appear here',
                style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: reports.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final data = reports[index].data() as Map<String, dynamic>;
        final status = data['status'] ?? 'pending';
        final category = data['category'] ?? '';
        final description = data['description'] ?? '';
        final createdAt = data['createdAt'] != null
            ? (data['createdAt'] as Timestamp).toDate()
            : DateTime.now();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _statusColor(status).withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5C5C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.bug_report_outlined,
                        color: Color(0xFFFF5C5C), size: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      category,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
                          color: Color(0xFF1F2937)),
                    ),
                  ),
                  _StatusChip(status: status),
                ],
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  description,
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.5),
                ),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.access_time,
                      size: 12, color: Colors.grey[400]),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(createdAt),
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey[400]),
                  ),
                ],
              ),
              if (status == 'resolved') ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Colors.green.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline,
                          color: Colors.green, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Issue resolved by our team',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════
//  FEEDBACK LIST
// ════════════════════════════════════════════════════════════
class _FeedbackList extends StatelessWidget {
  final List<QueryDocumentSnapshot> feedbacks;

  const _FeedbackList({required this.feedbacks});

  @override
  Widget build(BuildContext context) {
    if (feedbacks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rate_review_outlined,
                size: 56, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('No feedback yet',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937))),
            const SizedBox(height: 6),
            Text('Your submitted feedback will appear here',
                style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: feedbacks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final data = feedbacks[index].data() as Map<String, dynamic>;
        final status = data['status'] ?? 'pending';
        final message = data['message'] ?? '';
        final createdAt = data['createdAt'] != null
            ? (data['createdAt'] as Timestamp).toDate()
            : DateTime.now();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFF7C6EF7).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.rate_review_outlined,
                        color: Color(0xFF7C6EF7), size: 22),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Feedback',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
                          color: Color(0xFF1F2937)),
                    ),
                  ),
                  _StatusChip(status: status),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.5),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.access_time,
                      size: 12, color: Colors.grey[400]),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(createdAt),
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey[400]),
                  ),
                ],
              ),
              if (status == 'read') ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.done_all,
                          color: Colors.grey[500], size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Reviewed by our team, thank you!',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════
//  HELPERS
// ════════════════════════════════════════════════════════════
class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case 'resolved':
        color = Colors.green;
        label = 'Resolved';
        break;
      case 'read':
        color = Colors.grey;
        label = 'Reviewed';
        break;
      default:
        color = Colors.orange;
        label = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color),
      ),
    );
  }
}

Color _statusColor(String status) {
  switch (status) {
    case 'resolved':
      return Colors.green;
    case 'read':
      return Colors.grey;
    default:
      return Colors.orange;
  }
}

String _formatDate(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inHours < 1) return '${diff.inMinutes}m ago';
  if (diff.inDays < 1) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return '${date.day}/${date.month}/${date.year}';
}
// lib/widgets/expandable_message_card.dart
import 'package:flutter/material.dart';
import '../models/conversation_statistic.dart';

class ExpandableMessageCard extends StatefulWidget {
  final ConversationStatistic stat;
  final VoidCallback onReviewed; // callback để báo cho màn hình

  const ExpandableMessageCard({
    super.key,
    required this.stat,
    required this.onReviewed,
  });

  @override
  State<ExpandableMessageCard> createState() => _ExpandableMessageCardState();
}

class _ExpandableMessageCardState extends State<ExpandableMessageCard> {
  bool _isExpanded = false;

  Color _getStatusColor(bool hasError) =>
      hasError ? Colors.orange : Colors.green;

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final stat = widget.stat;
    final mainTip = stat.improvements.isNotEmpty ? stat.improvements.first : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: stat.isReviewed ? Colors.grey[100] : null,
      child: InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _getStatusColor(stat.hasError),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      stat.userMessage,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDateTime(stat.timestamp),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
              if (mainTip.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    mainTip,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (stat.hasError && stat.correction != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      stat.correction!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.orange[900],
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              if (_isExpanded) ...[
                const SizedBox(height: 12),
                Divider(color: Colors.grey[300], height: 1),
                const SizedBox(height: 12),
                if (stat.hasError && stat.correction != null) ...[
                  _buildDetailSection(
                    context,
                    'Sửa:',
                    stat.correction!,
                    Colors.orange,
                  ),
                  const SizedBox(height: 12),
                ],
                _buildDetailSection(
                  context,
                  'Gợi ý:',
                  stat.improvements.map((e) => '• $e').join('\n'),
                  _getStatusColor(stat.hasError),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        stat.isReviewed = true;
                      });
                      widget.onReviewed();
                    },
                    child: const Text('Đánh dấu đã xem'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    String title,
    String content,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                height: 1.4,
              ),
        ),
      ],
    );
  }
}

// lib/widgets/expandable_message_card.dart
import 'package:flutter/material.dart';
import '../models/conversation_statistic.dart';

class ExpandableMessageCard extends StatelessWidget {
  final ConversationStatistic stat;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onReviewed;

  const ExpandableMessageCard({
    super.key,
    required this.stat,
    required this.isExpanded,
    required this.onToggle,
    required this.onReviewed,
  });

  Color _getStatusColor() => Colors.grey.shade500;

  @override
  Widget build(BuildContext context) {
    final mainTip = stat.improvements.isNotEmpty ? stat.improvements.first : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: stat.isReviewed ? Colors.grey[100] : null,
      child: InkWell(
        onTap: onToggle,
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
                      color: _getStatusColor(),
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
              if (stat.correction != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            stat.correction!,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Colors.grey.shade700,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (isExpanded) ...[
                const SizedBox(height: 12),
                Divider(color: Colors.grey[300], height: 1),
                const SizedBox(height: 12),
                if (stat.correction != null) ...[
                  _buildDetailSection(
                    context,
                    'Sửa:',
                    stat.correction!,
                    Colors.grey.shade700,
                  ),
                  const SizedBox(height: 12),
                ],
                _buildDetailSection(
                  context,
                  'Gợi ý:',
                  stat.improvements.map((e) => '• $e').join('\n'),
                  _getStatusColor(),
                ),
                const SizedBox(height: 12),
                if (!stat.isReviewed)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        stat.isReviewed = true;
                        onReviewed();
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text('Đã xem'),
                        ],
                      ),
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

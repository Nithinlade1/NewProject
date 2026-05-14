import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/avatar_widget.dart';
import '../../../core/widgets/badge_widget.dart';
import '../../../data/models/kutcom_model.dart';
import 'kutcom_card.dart';

class KutComGroupTile extends StatefulWidget {
  final KutComGroup group;
  final ValueChanged<KutComModel> onKutComTap;

  const KutComGroupTile({
    super.key,
    required this.group,
    required this.onKutComTap,
  });

  @override
  State<KutComGroupTile> createState() => _KutComGroupTileState();
}

class _KutComGroupTileState extends State<KutComGroupTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isLocationGroup =
        widget.group.type == KutComGroupType.locationDeliveryGroup;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  AvatarWidget(
                    name: widget.group.name,
                    size: 52,
                    backgroundColor: isLocationGroup
                        ? AppColors.secondary.withValues(alpha: 0.15)
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.group.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isLocationGroup
                                    ? AppColors.secondary.withValues(alpha: 0.1)
                                    : AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                isLocationGroup ? 'Location' : 'Group',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isLocationGroup
                                      ? AppColors.secondary
                                      : AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        InterestBadge(
                          activeCount: widget.group.totalActiveInterest,
                          passiveCount: widget.group.totalPassiveInterest,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (widget.group.totalUnread > 0)
                    BadgeWidget(count: widget.group.totalUnread),
                  const SizedBox(width: 4),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            Container(
              color: const Color(0xFFFAFAFA),
              child: Column(
                children: widget.group.kutcoms.map((kutcom) {
                  return KutComCard(
                    kutcom: kutcom,
                    onTap: () => widget.onKutComTap(kutcom),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

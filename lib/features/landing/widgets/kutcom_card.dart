import 'package:flutter/material.dart';
import '../../../core/widgets/avatar_widget.dart';
import '../../../core/widgets/badge_widget.dart';
import '../../../data/models/kutcom_model.dart';

class KutComCard extends StatelessWidget {
  final KutComModel kutcom;
  final VoidCallback onTap;

  const KutComCard({
    super.key,
    required this.kutcom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              AvatarWidget(
                name: kutcom.name,
                imageUrl: kutcom.imageUrl,
                size: 52,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kutcom.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    InterestBadge(
                      activeCount: kutcom.activeInterest,
                      passiveCount: kutcom.passiveInterest,
                    ),
                  ],
                ),
              ),
              if (kutcom.unreadMessages > 0)
                BadgeWidget(count: kutcom.unreadMessages),
            ],
          ),
        ),
      ),
    );
  }
}

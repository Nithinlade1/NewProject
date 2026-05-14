import 'package:flutter/material.dart';
import '../../../core/widgets/radio_option.dart';
import '../landing_screen.dart';

class FilterPopup extends StatefulWidget {
  final FilterType currentFilter;
  final ValueChanged<FilterType> onFilterChanged;

  const FilterPopup({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  State<FilterPopup> createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {
  late FilterType _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            RadioOption<FilterType>(
              value: FilterType.mySequence,
              groupValue: _selected,
              title: 'My Sequence',
              subtitle: 'Custom order',
              onChanged: (v) => setState(() => _selected = v),
            ),
            const SizedBox(height: 10),
            RadioOption<FilterType>(
              value: FilterType.unreadMessages,
              groupValue: _selected,
              title: 'Unread Messages',
              subtitle: 'Most unread first',
              onChanged: (v) => setState(() => _selected = v),
            ),
            const SizedBox(height: 10),
            RadioOption<FilterType>(
              value: FilterType.latest,
              groupValue: _selected,
              title: 'Latest',
              subtitle: 'Most recent activity',
              onChanged: (v) => setState(() => _selected = v),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onFilterChanged(_selected);
                  Navigator.of(context).pop();
                },
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

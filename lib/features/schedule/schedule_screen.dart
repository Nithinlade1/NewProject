import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/models/schedule_model.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<ScheduleModel> _schedules = [
    ScheduleModel(
      id: '1',
      kutComId: '1',
      kutComName: 'Sarangi',
      date: DateTime(2026, 5, 15),
      time: '09:00 AM',
    ),
    ScheduleModel(
      id: '2',
      kutComId: '1',
      kutComName: 'Sarangi',
      date: DateTime(2026, 5, 15),
      time: '02:00 PM',
    ),
    ScheduleModel(
      id: '3',
      kutComId: '2',
      kutComName: 'Mekhala',
      date: DateTime(2026, 5, 16),
      time: '10:00 AM',
    ),
  ];

  final bool _isLoading = false;

  void _addSchedule() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _AddScheduleSheet(
        onAdd: (schedule) {
          setState(() => _schedules.add(schedule));
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: const Text('Schedules'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addSchedule,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget(message: 'Loading schedules...')
          : _schedules.isEmpty
              ? const EmptyStateWidget(
                  message: AppStrings.noSchedules,
                  icon: Icons.schedule,
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _schedules.length,
                  itemBuilder: (context, index) {
                    return _ScheduleCard(
                      schedule: _schedules[index],
                      onDelete: () {
                        setState(() => _schedules.removeAt(index));
                      },
                    );
                  },
                ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final ScheduleModel schedule;
  final VoidCallback onDelete;

  const _ScheduleCard({required this.schedule, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.schedule,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.kutComName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${schedule.formattedDate} at ${schedule.time}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.danger),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddScheduleSheet extends StatefulWidget {
  final ValueChanged<ScheduleModel> onAdd;

  const _AddScheduleSheet({required this.onAdd});

  @override
  State<_AddScheduleSheet> createState() => _AddScheduleSheetState();
}

class _AddScheduleSheetState extends State<_AddScheduleSheet> {
  String _kutComName = 'Sarangi';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTime = '09:00 AM';

  final List<String> _times = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Schedule',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _kutComName,
            decoration: const InputDecoration(labelText: 'KutCom'),
            items: ['Sarangi', 'Mekhala', 'Priya Homes']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => _kutComName = v!),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today, color: AppColors.primary),
            title: const Text('Date'),
            subtitle: Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
            ),
            onTap: _pickDate,
          ),
          DropdownButtonFormField<String>(
            value: _selectedTime,
            decoration: const InputDecoration(labelText: 'Time'),
            items: _times
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => _selectedTime = v!),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Add Schedule',
            onPressed: () {
              widget.onAdd(ScheduleModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                kutComId: '1',
                kutComName: _kutComName,
                date: _selectedDate,
                time: _selectedTime,
              ));
            },
          ),
        ],
      ),
    );
  }
}

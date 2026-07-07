import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';

import '../glass_container.dart';
import '../../../providers/library_provider.dart';

class GoalSettingsSheet extends ConsumerStatefulWidget {
  const GoalSettingsSheet({super.key});

  @override
  ConsumerState<GoalSettingsSheet> createState() => _GoalSettingsSheetState();
}

class _GoalSettingsSheetState extends ConsumerState<GoalSettingsSheet> {
  late double _pagesValue;
  late double _minutesValue;
  late double _wpValue;
  late String _activeType;

  late TextEditingController _pagesController;
  late TextEditingController _minutesController;
  late TextEditingController _wpController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(libraryProvider);
    _pagesValue = state.weeklyPageGoal;
    _minutesValue = state.weeklyMinuteGoal;
    _wpValue = state.weeklyWPGoal;
    _activeType = state.weeklyGoalType;

    _pagesController = TextEditingController(
      text: _pagesValue.toInt().toString(),
    );
    _minutesController = TextEditingController(
      text: _minutesValue.toInt().toString(),
    );
    _wpController = TextEditingController(text: _wpValue.toInt().toString());
  }

  @override
  void dispose() {
    _pagesController.dispose();
    _minutesController.dispose();
    _wpController.dispose();
    super.dispose();
  }

  void _updatePages(double newValue) {
    setState(() {
      _pagesValue = newValue.clamp(0, 10000);
      _pagesController.text = _pagesValue.toInt().toString();
    });
  }

  void _updateMinutes(double newValue) {
    setState(() {
      _minutesValue = newValue.clamp(0, 10000);
      _minutesController.text = _minutesValue.toInt().toString();
    });
  }

  void _updateWP(double newValue) {
    setState(() {
      _wpValue = newValue.clamp(0, 10000);
      _wpController.text = _wpValue.toInt().toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: GlassContainer(
          borderRadius: 20,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weekly Reading Goals',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: t.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Set targets for the metrics you want to track.',
                style: TextStyle(color: t.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 24),

              _buildGoalInput(
                t: t,
                title: 'Pages Goal',
                unit: 'pages',
                controller: _pagesController,
                value: _pagesValue,
                isActive: _activeType == 'pages',
                onChanged: (val) => _pagesValue = val,
                onDecrement: () => _updatePages(_pagesValue - 10),
                onIncrement: () => _updatePages(_pagesValue + 10),
                onSelect: () => setState(() => _activeType = 'pages'),
              ),

              const SizedBox(height: 20),
              _buildGoalInput(
                t: t,
                title: 'Minutes Goal',
                unit: 'minutes',
                controller: _minutesController,
                value: _minutesValue,
                isActive: _activeType == 'minutes',
                onChanged: (val) => _minutesValue = val,
                onDecrement: () => _updateMinutes(_minutesValue - 10),
                onIncrement: () => _updateMinutes(_minutesValue + 10),
                onSelect: () => setState(() => _activeType = 'minutes'),
              ),

              const SizedBox(height: 20),
              _buildGoalInput(
                t: t,
                title: 'WP Goal',
                unit: 'WP',
                controller: _wpController,
                value: _wpValue,
                isActive: _activeType == 'wp',
                onChanged: (val) => _wpValue = val,
                onDecrement: () => _updateWP(_wpValue - 100),
                onIncrement: () => _updateWP(_wpValue + 100),
                onSelect: () => setState(() => _activeType = 'wp'),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    ref
                        .read(libraryProvider.notifier)
                        .updateWeeklyGoals(
                          pages: _pagesValue,
                          minutes: _minutesValue,
                          wp: _wpValue,
                          activeType: _activeType,
                        );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: t.primary,
                    foregroundColor: t.textOnPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: TibebRadius.borderLg,
                    ),
                  ),
                  child: const Text('Save Goals'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalInput({
    required TibebThemeExtension t,
    required String title,
    required String unit,
    required TextEditingController controller,
    required double value,
    required bool isActive,
    required Function(double) onChanged,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
    required VoidCallback onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: t.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: onSelect,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? t.primary.withValues(alpha: 0.2)
                      : t.borderSubtle,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isActive
                        ? t.primary.withValues(alpha: 0.5)
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  isActive ? 'Active' : 'Show on Graph',
                  style: TextStyle(
                    color: isActive ? t.primary : t.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  IntrinsicWidth(
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isActive ? t.primary : t.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (val) {
                        final dVal = double.tryParse(val);
                        if (dVal != null) {
                          onChanged(dVal);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: 14,
                      color: t.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                _buildValueBtn(t, Icons.remove, onDecrement),
                const SizedBox(width: 8),
                _buildValueBtn(t, Icons.add, onIncrement),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildValueBtn(TibebThemeExtension t, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: t.borderSubtle,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: t.textPrimary),
      ),
    );
  }
}

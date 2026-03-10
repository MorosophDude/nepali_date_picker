import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const int _monthPickerColumnCount = 3;
const double _monthPickerPadding = 16.0;
const double _monthPickerRowHeight = 52.0;
const double _monthPickerRowSpacing = 8.0;

// 14 is a common font size used to compute the effective text scale.
const double _fontSizeToScale = 14.0;

/// A scrollable grid of months to allow picking a month.
///
class MonthPicker extends StatefulWidget {
  /// Creates a month picker.
  ///
  /// The [lastDate] must be after the [firstDate].
  MonthPicker({
    super.key,
    DateTime? currentDate,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    this.calendarDelegate = const GregorianCalendarDelegate(),
  }) : assert(!firstDate.isAfter(lastDate)),
       currentDate = calendarDelegate.dateOnly(currentDate ?? DateTime.now());

  /// The current date.
  ///
  /// This date is subtly highlighted in the picker.
  final DateTime currentDate;

  /// The earliest date the user is permitted to pick.
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  final DateTime lastDate;

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime? selectedDate;

  /// Called when the user picks a month.
  final ValueChanged<DateTime> onChanged;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.material.calendar_date_picker.calendarDelegate}
  final CalendarDelegate<DateTime> calendarDelegate;

  @override
  State<MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker> {
  ScrollController? _scrollController;
  final WidgetStatesController _statesController = WidgetStatesController();

  // The approximate number of months necessary to fill the available space.
  static const int minMonths = 12;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: _scrollOffsetForMonth(
        widget.selectedDate ?? widget.firstDate,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _statesController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MonthPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate &&
        widget.selectedDate != null) {
      _scrollController!.jumpTo(_scrollOffsetForMonth(widget.selectedDate!));
    }
  }

  double _scrollOffsetForMonth(DateTime date) {
    final int initialMonthIndex = date.month - widget.firstDate.month;
    final int initialMonthRow = initialMonthIndex ~/ _monthPickerColumnCount;
    // Move the offset down by 2 rows to approximately center it.
    final int centeredMonthRow = initialMonthRow - 2;
    return _itemCount < minMonths
        ? 0
        : centeredMonthRow * _monthPickerRowHeight;
  }

  Widget _buildMonthItem(BuildContext context, int index) {
    final DatePickerThemeData datePickerTheme = DatePickerTheme.of(context);
    final DatePickerThemeData defaults = DatePickerTheme.defaults(context);

    T? effectiveValue<T>(T? Function(DatePickerThemeData? theme) getProperty) {
      return getProperty(datePickerTheme) ?? getProperty(defaults);
    }

    T? resolve<T>(
      WidgetStateProperty<T>? Function(DatePickerThemeData? theme) getProperty,
      Set<WidgetState> states,
    ) {
      return effectiveValue((DatePickerThemeData? theme) {
        return getProperty(theme)?.resolve(states);
      });
    }

    final double textScaleFactor =
        MediaQuery.textScalerOf(
          context,
        ).clamp(maxScaleFactor: 3.0).scale(_fontSizeToScale) /
        _fontSizeToScale;

    // Backfill the _MonthPicker with disabled months if necessary.
    final int offset = _itemCount < minMonths
        ? (minMonths - _itemCount) ~/ 2
        : 0;
    final int month = widget.firstDate.month + index - offset;
    final isSelected = month == widget.selectedDate?.month;
    final isCurrentMonth = month == widget.currentDate.month;
    final bool isDisabled =
        month < widget.firstDate.month || month > widget.lastDate.month;
    final double decorationHeight = 36.0 * textScaleFactor;
    final double decorationWidth = 72.0 * textScaleFactor;

    final states = <WidgetState>{
      if (isDisabled) WidgetState.disabled,
      if (isSelected) WidgetState.selected,
    };

    final Color? textColor = resolve<Color?>(
      (DatePickerThemeData? theme) => isCurrentMonth
          ? theme?.todayForegroundColor
          : theme?.yearForegroundColor,
      states,
    );
    final Color? background = resolve<Color?>(
      (DatePickerThemeData? theme) => isCurrentMonth
          ? theme?.todayBackgroundColor
          : theme?.yearBackgroundColor,
      states,
    );
    final WidgetStateProperty<Color?> overlayColor =
        WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => effectiveValue(
            (DatePickerThemeData? theme) =>
                theme?.yearOverlayColor?.resolve(states),
          ),
        );

    final OutlinedBorder monthShape = resolve<OutlinedBorder?>(
      (DatePickerThemeData? theme) => theme?.yearShape,
      states,
    )!;

    BorderSide? borderSide;
    if (isCurrentMonth) {
      borderSide = datePickerTheme.todayBorder ?? defaults.todayBorder;
      if (borderSide != null) {
        borderSide = borderSide.copyWith(color: textColor);
      }
    }
    final decoration = ShapeDecoration(
      color: background,
      shape: monthShape.copyWith(side: borderSide),
    );

    final TextStyle? itemStyle =
        (datePickerTheme.yearStyle ?? defaults.yearStyle)?.apply(
          color: textColor,
        );
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    Widget monthItem = Center(
      child: Container(
        decoration: decoration,
        height: decorationHeight,
        width: decorationWidth+10,
        alignment: Alignment.center,
        child: Semantics(
          selected: isSelected,
          enabled: !isDisabled,
          button: true,
          child: Text(() {
            final date = widget.calendarDelegate.getMonth(
              widget.calendarDelegate.now().year,
              month,
            );
            final monthYear = widget.calendarDelegate.formatMonthYear(
              date,
              localizations,
            );
            return monthYear.split(' ').first;
          }(), style: itemStyle),
        ),
      ),
    );

    if (!isDisabled) {
      DateTime date = widget.calendarDelegate.getMonth(
        widget.calendarDelegate.now().year,
        month,
      );
      if (date.isBefore(
        widget.calendarDelegate.getMonth(
          widget.firstDate.year,
          widget.firstDate.month,
        ),
      )) {
        // Ignore firstDate.day because we're just working in years and months here.
        assert(date.year == widget.firstDate.year);
        date = widget.calendarDelegate.getMonth(month, widget.firstDate.month);
      } else if (date.isAfter(widget.lastDate)) {
        // No need to ignore the day here because it can only be bigger than what we care about.
        assert(date.year == widget.lastDate.year);
        date = widget.calendarDelegate.getMonth(month, widget.lastDate.month);
      }
      _statesController.value = states;
      monthItem = InkWell(
        key: ValueKey<int>(month),
        onTap: () => widget.onChanged(date),
        statesController: _statesController,
        overlayColor: overlayColor,
        child: monthItem,
      );
    }

    return monthItem;
  }

  int get _itemCount {
    return widget.lastDate.month - widget.firstDate.month + 1;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          _monthPickerPadding + // Padding of 16.0 at top
          _monthPickerRowHeight * // Height of each row
              minMonths /
              _monthPickerColumnCount + // No. of rows (total months / columns)
          _monthPickerPadding, // Padding of 16.0 at bottom
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Divider(),
          Expanded(
            child: Material(
              type: MaterialType.transparency,
              child: GridView.builder(
                controller: _scrollController,
                dragStartBehavior: widget.dragStartBehavior,
                gridDelegate: _MonthPickerGridDelegate(context),
                itemBuilder: _buildMonthItem,
                itemCount: math.max(_itemCount, minMonths),
                padding: const EdgeInsets.symmetric(
                  horizontal: _monthPickerPadding,
                ),
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class _MonthPickerGridDelegate extends SliverGridDelegate {
  const _MonthPickerGridDelegate(this.context);

  final BuildContext context;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double textScaleFactor =
        MediaQuery.textScalerOf(
          context,
        ).clamp(maxScaleFactor: 3.0).scale(_fontSizeToScale) /
        _fontSizeToScale;
    final int scaledMonthPickerColumnCount = textScaleFactor > 1.65
        ? _monthPickerColumnCount - 1
        : _monthPickerColumnCount;
    final double tileWidth = math.max(
      (constraints.crossAxisExtent -
              (scaledMonthPickerColumnCount - 1) * _monthPickerRowSpacing) /
          scaledMonthPickerColumnCount,
      0.0,
    );
    final double scaledMonthPickerRowHeight = textScaleFactor > 1
        ? _monthPickerRowHeight + ((textScaleFactor - 1) * 9)
        : _monthPickerRowHeight;
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: scaledMonthPickerRowHeight,
      crossAxisCount: scaledMonthPickerColumnCount,
      crossAxisStride: tileWidth + _monthPickerRowSpacing,
      mainAxisStride: scaledMonthPickerRowHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_MonthPickerGridDelegate oldDelegate) => false;
}

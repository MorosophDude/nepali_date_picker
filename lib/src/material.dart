// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';

import 'nepali_calendar_delegate.dart';
import 'overrides/month_picker.dart';

/// Shows a dialog containing a Material Design date picker
/// with Bikram Sambat Calendar.
///
/// The returned [Future] resolves to the date selected by the user when the
/// user confirms the dialog. If the user cancels the dialog, null is returned.
Future<NepaliDateTime?> showNepaliDatePicker({
  required BuildContext context,
  required NepaliDateTime firstDate,
  required NepaliDateTime lastDate,
  NepaliDateTime? initialDate,
  NepaliDateTime? currentDate,
  DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
  SelectableDayPredicate? selectableDayPredicate,
  String? helpText,
  String? cancelText,
  String? confirmText,
  Locale? locale,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  TextDirection? textDirection,
  TransitionBuilder? builder,
  DatePickerMode initialDatePickerMode = DatePickerMode.day,
  String? errorFormatText,
  String? errorInvalidText,
  String? fieldHintText,
  String? fieldLabelText,
  TextInputType? keyboardType,
  Offset? anchorPoint,
  final ValueChanged<DatePickerEntryMode>? onDatePickerModeChange,
  final Icon? switchToInputEntryModeIcon,
  final Icon? switchToCalendarEntryModeIcon,
}) async {
  final date = await showDatePicker(
    context: context,
    firstDate: firstDate,
    lastDate: lastDate,
    initialDate: initialDate,
    currentDate: currentDate,
    initialEntryMode: initialEntryMode,
    selectableDayPredicate: selectableDayPredicate,
    helpText: helpText,
    cancelText: cancelText,
    confirmText: confirmText,
    locale: locale,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    textDirection: textDirection,
    builder: builder,
    initialDatePickerMode: initialDatePickerMode,
    errorFormatText: errorFormatText,
    errorInvalidText: errorInvalidText,
    fieldHintText: fieldHintText,
    fieldLabelText: fieldLabelText,
    keyboardType: keyboardType,
    anchorPoint: anchorPoint,
    onDatePickerModeChange: onDatePickerModeChange,
    switchToInputEntryModeIcon: switchToInputEntryModeIcon,
    switchToCalendarEntryModeIcon: switchToCalendarEntryModeIcon,
    calendarDelegate: const NepaliCalendarDelegate(),
  );

  return date as NepaliDateTime?;
}

/// Shows a full screen modal dialog containing a Material Design date range
/// picker with Bikram Sambat Calendar.
///
/// The returned [Future] resolves to the [DateTimeRange] selected by the user
/// when the user saves their selection. If the user cancels the dialog, null is
/// returned.
Future<DateTimeRange<NepaliDateTime>?> showNepaliDateRangePicker({
  required BuildContext context,
  required NepaliDateTime firstDate,
  required NepaliDateTime lastDate,
  DateTimeRange<NepaliDateTime>? initialDateRange,
  NepaliDateTime? currentDate,
  DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
  String? helpText,
  String? cancelText,
  String? confirmText,
  String? saveText,
  String? errorFormatText,
  String? errorInvalidText,
  String? errorInvalidRangeText,
  String? fieldStartHintText,
  String? fieldEndHintText,
  String? fieldStartLabelText,
  String? fieldEndLabelText,
  Locale? locale,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  TextDirection? textDirection,
  TransitionBuilder? builder,
  Offset? anchorPoint,
  TextInputType keyboardType = TextInputType.datetime,
  final Icon? switchToInputEntryModeIcon,
  final Icon? switchToCalendarEntryModeIcon,
  SelectableDayForRangePredicate? selectableDayPredicate,
}) async {
  final dateRange = await showDateRangePicker(
    context: context,
    firstDate: firstDate,
    lastDate: lastDate,
    initialDateRange: initialDateRange,
    currentDate: currentDate,
    initialEntryMode: initialEntryMode,
    helpText: helpText,
    cancelText: cancelText,
    confirmText: confirmText,
    saveText: saveText,
    errorFormatText: errorFormatText,
    errorInvalidText: errorInvalidText,
    errorInvalidRangeText: errorInvalidRangeText,
    fieldStartHintText: fieldStartHintText,
    fieldEndHintText: fieldEndHintText,
    fieldStartLabelText: fieldStartLabelText,
    fieldEndLabelText: fieldEndLabelText,
    locale: locale,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    textDirection: textDirection,
    builder: builder,
    anchorPoint: anchorPoint,
    keyboardType: keyboardType,
    switchToInputEntryModeIcon: switchToInputEntryModeIcon,
    switchToCalendarEntryModeIcon: switchToCalendarEntryModeIcon,
    selectableDayPredicate: selectableDayPredicate,
    calendarDelegate: const NepaliCalendarDelegate(),
  );

  if (dateRange == null) return null;

  final DateTime(year: sYear, month: sMonth, day: sDay) = dateRange.start;
  final DateTime(year: eYear, month: eMonth, day: eDay) = dateRange.end;

  return DateTimeRange(
    start: NepaliDateTime(sYear, sMonth, sDay),
    end: NepaliDateTime(eYear, eMonth, eDay),
  );
}

/// Shows a dialog containing a Material Design year picker
/// with Bikram Sambat Calendar.
///
/// The returned [Future] resolves to the year selected by the user when the
/// user taps on a year in the dialog. If the user taps outside of the dialog,
/// null is returned.
///
/// The [firstYear] is the earliest allowable year. The [lastYear] is the last
/// allowable date. For each of these [DateTime] parameters, only their year is
/// considered. Rest of it's fields (month, date, and time) are ignored.
///
/// The [currentYear] represents the current year. This year will be subtly
/// highlighted in the year grid. If null, the year field of `DateTime.now()`
/// will be used.
///
/// The [selectedYear] represents the selected year. This will be highlighted in
/// the year grid.
///
/// Optional strings for the [helpText] allow you to override the default text
/// used as label on the top of the dialog.
///
/// An optional [locale] argument can be used to set the locale for the date
/// picker. It defaults to the ambient locale provided by [Localizations].
///
/// An optional [textDirection] argument can be used to set the text direction
/// ([TextDirection.ltr] or [TextDirection.rtl]) for the date picker. It
/// defaults to the ambient text direction provided by [Directionality]. If both
/// [locale] and [textDirection] are non-null, [textDirection] overrides the
/// direction chosen for the [locale].
///
/// The [context], [useRootNavigator], [routeSettings], [barrierDismissible],
/// [barrierColor], [barrierLabel] and [anchorPoint] arguments are passed to
/// [showDialog], the documentation for which discusses how it is used.
/// [context] and [useRootNavigator] must be non-null.
///
/// The [builder] parameter can be used to wrap the dialog widget to add
/// inherited widgets like [Theme].
///
/// Use [showNepaliYearPicker] function like this
///
/// ```dart
///
/// NepaliDateTime? _selectedYear;
/// ...
/// onTap: () {
///   final today = NepaliDateTime.now();
///   final _selectedYear = await showNepaliYearPicker(
///     context: context,
///     firstYear: NepaliDateTime(today.year - 3),
///     lastYear: NepaliDateTime(today.year + 5),
///     selectedYear: _selectedYear,
///   );
///   print("Do something useful with year $_selectedYear");
/// }
/// ...
/// ```
Future<NepaliDateTime?> showNepaliYearPicker({
  required BuildContext context,
  required NepaliDateTime firstYear,
  required NepaliDateTime lastYear,
  NepaliDateTime? selectedYear,
  String? helpText,
  NepaliDateTime? currentYear,
  Locale? locale,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  TextDirection? textDirection,
  TransitionBuilder? builder,
  Offset? anchorPoint,
}) async {
  firstYear = NepaliDateTime(firstYear.year);
  lastYear = NepaliDateTime(lastYear.year);
  assert(
    !lastYear.isBefore(firstYear),
    'lastYear $lastYear must be on or after firstYear $firstYear.',
  );
  assert(debugCheckHasMaterialLocalizations(context));

  Widget picker = YearPicker(
    firstDate: firstYear,
    lastDate: lastYear,
    currentDate: currentYear ?? NepaliDateTime.now(),
    selectedDate: selectedYear,
    onChanged: (value) => Navigator.pop(context, value),
    calendarDelegate: NepaliCalendarDelegate(),
  );

  if (textDirection != null) {
    picker = Directionality(textDirection: textDirection, child: picker);
  }

  if (locale != null) {
    picker = Localizations.override(
      context: context,
      locale: locale,
      child: picker,
    );
  } else {
    final DatePickerThemeData datePickerTheme = DatePickerTheme.of(context);
    if (datePickerTheme.locale != null) {
      picker = Localizations.override(
        context: context,
        locale: datePickerTheme.locale,
        child: picker,
      );
    }
  }

  picker = Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
    clipBehavior: Clip.antiAlias,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              helpText ??
                  (NepaliUtils().language == Language.english
                      ? 'SELECT YEAR'
                      : 'साल चयन गर्नुहोस'),
              style: Theme.of(context).textTheme.labelSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Expanded(child: picker),
      ],
    ),
  );

  return showDialog<NepaliDateTime>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (BuildContext context) =>
        builder == null ? picker : builder(context, picker),
    anchorPoint: anchorPoint,
  );
}

/// Shows a dialog containing a Material Design month picker
/// with Bikram Sambat Calendar.
///
/// The returned [Future] resolves to the month selected by the user when the
/// user taps on a month in the dialog. If the user taps outside of the dialog,
/// null is returned.
///
/// The [firstMonth] is the earliest allowable month. The [lastMonth] is the
/// last allowable date. Default value for [firstMonth] is 1 and for [lastMonth]
/// is 12.
///
/// The [currentMonth] represents the current month. This month will be subtly
/// highlighted in the month grid. If null, the month field of `DateTime.now()`
/// will be used.
///
/// The [selectedMonth] represents the selected month. This will be highlighted
/// in the month grid.
///
/// Optional strings for the [helpText] allow you to override the default text
/// used as label on the top of the dialog.
///
/// An optional [locale] argument can be used to set the locale for the date
/// picker. It defaults to the ambient locale provided by [Localizations].
///
/// An optional [textDirection] argument can be used to set the text direction
/// ([TextDirection.ltr] or [TextDirection.rtl]) for the date picker. It
/// defaults to the ambient text direction provided by [Directionality]. If both
/// [locale] and [textDirection] are non-null, [textDirection] overrides the
/// direction chosen for the [locale].
///
/// The [context], [useRootNavigator], [routeSettings], [barrierDismissible],
/// [barrierColor], [barrierLabel] and [anchorPoint] arguments are passed to
/// [showDialog], the documentation for which discusses how it is used.
/// [context] and [useRootNavigator] must be non-null.
///
/// The [builder] parameter can be used to wrap the dialog widget to add
/// inherited widgets like [Theme].
///
/// Use [showNepaliMonthPicker] function like this
///
/// ```dart
///
/// NepaliDateTime? _selectedMonth;
/// ...
/// onTap: () {
///   final pickedMonth = await showNepaliMonthPicker(
///     context: context,
///     selectedMonth: _selectedMonth,
///   );
///   _selectedMonth = pickedMonth;
///   print("Do something useful with month ${_selectedMonth.month}");
/// }
/// ...
/// ```
Future<NepaliDateTime?> showNepaliMonthPicker({
  required BuildContext context,
  NepaliDateTime? firstMonth,
  NepaliDateTime? lastMonth,
  NepaliDateTime? selectedMonth,
  String? helpText,
  NepaliDateTime? currentMonth,
  Locale? locale,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  TextDirection? textDirection,
  TransitionBuilder? builder,
  Offset? anchorPoint,
}) async {
  final now = NepaliDateTime.now();
  firstMonth = firstMonth ?? NepaliDateTime(now.year, 1);
  lastMonth = lastMonth ?? NepaliDateTime(now.year, 12);
  assert(
    !lastMonth.isBefore(firstMonth),
    'lastMonth $lastMonth must be on or after firstMonth $firstMonth.',
  );
  assert(debugCheckHasMaterialLocalizations(context));

  Widget picker = MonthPicker(
    firstDate: firstMonth,
    lastDate: lastMonth,
    currentDate: currentMonth ?? now,
    selectedDate: selectedMonth,
    onChanged: (value) => Navigator.pop(context, value),
    calendarDelegate: NepaliCalendarDelegate(),
  );

  if (textDirection != null) {
    picker = Directionality(textDirection: textDirection, child: picker);
  }

  if (locale != null) {
    picker = Localizations.override(
      context: context,
      locale: locale,
      child: picker,
    );
  } else {
    final DatePickerThemeData datePickerTheme = DatePickerTheme.of(context);
    if (datePickerTheme.locale != null) {
      picker = Localizations.override(
        context: context,
        locale: datePickerTheme.locale,
        child: picker,
      );
    }
  }

  picker = Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
    clipBehavior: Clip.antiAlias,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              helpText ??
                  (NepaliUtils().language == Language.english
                      ? 'SELECT Month'
                      : 'महिना चयन गर्नुहोस'),
              style: Theme.of(context).textTheme.labelSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Flexible(child: picker),
      ],
    ),
  );

  return showDialog<NepaliDateTime>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (BuildContext context) =>
        builder == null ? picker : builder(context, picker),
    anchorPoint: anchorPoint,
  );
}

import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

///
class MonthPickerWidget extends StatefulWidget {
  const MonthPickerWidget({super.key});

  @override
  State<MonthPickerWidget> createState() => _MonthPickerWidgetState();
}

class _MonthPickerWidgetState extends State<MonthPickerWidget> {
  NepaliDateTime? _selectedMonth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_selectedMonth != null)
            Text(
              'Selected Month: ${NepaliDateFormat.MMMM().format(_selectedMonth!)}',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: FilledButton.tonal(
              onPressed: () async {
                final pickedMonth = await showNepaliMonthPicker(
                  context: context,
                  selectedMonth: _selectedMonth,
                );
                _selectedMonth = pickedMonth;
                setState(() {});
              },
              child: Text('SELECT NEW MONTH'),
            ),
          ),
        ],
      ),
    );
  }
}

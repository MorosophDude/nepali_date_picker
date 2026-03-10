import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

///
class YearPickerWidget extends StatefulWidget {
  const YearPickerWidget({super.key});

  @override
  State<YearPickerWidget> createState() => _YearPickerWidgetState();
}

class _YearPickerWidgetState extends State<YearPickerWidget> {
  final _today = NepaliDateTime.now();
  NepaliDateTime? _selectedYear;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_selectedYear != null)
            Text(
              'Selected Year: ${NepaliDateFormat.y().format(_selectedYear!)}',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: FilledButton.tonal(
              onPressed: () async {
                _selectedYear = await showNepaliYearPicker(
                  context: context,
                  firstYear: NepaliDateTime(_today.year - 10),
                  lastYear: NepaliDateTime(_today.year + 10),
                  selectedYear: _selectedYear,
                );
                setState(() {});
              },
              child: Text('SELECT YEAR'),
            ),
          ),
        ],
      ),
    );
  }
}

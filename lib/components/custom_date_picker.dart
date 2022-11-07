import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({Key? key, this.dateInput, this.enabled}) : super(key: key);
  final dateInput;
  final enabled;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 20, 10),
      child: TextFormField(
        validator: (val) {
          if(val == null || val.isEmpty) {
            return '* 발매일을 선택해야 합니다.';
          }
        },
        controller: widget.dateInput,
        decoration: InputDecoration(
          icon: Icon(Icons.calendar_today),
          labelText: '발매일',
          filled: true,
          fillColor: Colors.white70,
        ),
        readOnly: true,
        enabled: widget.enabled,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101)
          );

          if(pickedDate != null) {
            // print(pickedDate);
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            // print(formattedDate);

            setState(() {
              widget.dateInput.text = formattedDate;
            });
          } else {
            print('Date is not Selected!');
          }
        },
      ),
    );
  }
}

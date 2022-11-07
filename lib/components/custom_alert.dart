import 'package:flutter/material.dart';

class CustomAlert extends StatefulWidget {
  const CustomAlert({Key? key, this.title}) : super(key: key);
  final title;

  @override
  State<CustomAlert> createState() => _CustomAlertState();
}

class _CustomAlertState extends State<CustomAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      content: SizedBox(
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('확인'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

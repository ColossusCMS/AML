import 'package:flutter/material.dart';
import 'package:aml/stores/main_store.dart';
import 'package:provider/provider.dart';

class LoadingContainer extends StatelessWidget {
  const LoadingContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Align(
        alignment: Alignment.center,
        child: (context.watch<MainStore>().isIndicatorVisible) ? CircularProgressIndicator() : Text('검색결과 없음'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../theme/custom_themes.dart';

class TopButton extends StatefulWidget {
  const TopButton({Key? key, this.hiding}) : super(key: key);
  final hiding;

  @override
  State<TopButton> createState() => _TopButtonState();
}

class _TopButtonState extends State<TopButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.hiding.visible,
        builder: (context, bool value, child) => (value) ? FloatingActionButton(
          onPressed: () {
            widget.hiding.controller.animateTo(
                widget.hiding.controller.position.minScrollExtent,
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn
            );
          },
          child: Icon(Icons.expand_less),
          mini: true,
          backgroundColor: CustomColors.backgroundColor,
          foregroundColor: CustomColors.foregroundColor,
        ) : SizedBox()
    );
  }
}

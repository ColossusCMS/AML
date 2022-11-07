import 'package:flutter/material.dart';

class HideFloatingButton {
  final ScrollController controller = ScrollController();
  final ValueNotifier<bool> visible = ValueNotifier<bool>(false);

  HideFloatingButton() {
    visible.value = false;
    controller.addListener(() {
      if(controller.position.pixels > 50.0) {
        if(!visible.value) {
          visible.value = true;
        }
      } else {
        if(visible.value) {
          visible.value = false;
        }
      }
    });
  }

  void dispose() {
    controller.dispose();
    visible.dispose();
  }
}
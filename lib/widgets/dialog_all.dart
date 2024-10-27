import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogAll{
  DialogAll();

  void showAlertDialogCustom({required BuildContext context, required Text title, required List<Widget> body, required List<Widget> actions}){
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dialog',
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          title: title,
          content: SingleChildScrollView(
            child: ListBody(
              children: body,
            ),
          ),
          actions: actions
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: child,
          ),
        );
      },
    );

  }
}
import 'package:flutter/material.dart';

Future<void> dialogScaffold(
  BuildContext context, {
  required Widget content,
  Widget? title,
  Function? onOkpressed,
  Widget? okButtonChild,
  Function? onCancelPressed,
  Widget? cancelButtonChild,
  Function? oncustomButtonPressed,
  Widget? customButtonChild,
}) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        final actions = <Widget>[
          if (onOkpressed != null) ...[
            TextButton(
                onPressed: () {
                  onOkpressed();
                  Navigator.of(context).pop();
                },
                child: okButtonChild ?? const Text('OK'))
          ],
          if (onCancelPressed != null) ...[
            TextButton(
                onPressed: () {
                  onCancelPressed();
                  Navigator.of(context).pop();
                },
                child: cancelButtonChild ?? const Text('Cancel'))
          ],
          if (oncustomButtonPressed != null) ...[
            TextButton(
                onPressed: () {
                  oncustomButtonPressed();
                  Navigator.of(context).pop();
                },
                child: customButtonChild ?? Container())
          ],
        ];

        return AlertDialog(
          title: title ?? const Text(''),
          actions: actions,
          content: content,
        );
      });
}

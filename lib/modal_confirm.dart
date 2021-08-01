import 'package:flutter/material.dart';

Future<void> showConfirmDialog(
  BuildContext context, {
  required String? title,
  required VoidCallback onConfirmed,
  String? body,
  bool isCancelable = true,
}) =>
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: null,
      builder: (context) => AlertDialog(
        title: Text(title ?? ''),
        content: body == null ? null : Text(body),
        actions: [
          if (isCancelable)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirmed();
            },
            child: Text(isCancelable ? 'Confirm' : 'OK'),
          ),
        ],
      ),
    );

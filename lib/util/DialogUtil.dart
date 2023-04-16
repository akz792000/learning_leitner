import 'package:flutter/material.dart';

class DialogUtil {
  static okCancel(BuildContext context, String title, String description,
      VoidCallback? onPressed) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onPressed!();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static ok(BuildContext context, String title, String description,
      VoidCallback? onPressed) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onPressed!();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

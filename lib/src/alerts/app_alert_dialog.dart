import 'package:flutter/material.dart';

class AppAlertDialog extends StatelessWidget {
  final String confirmText;
  final VoidCallback onConfirm;
  final IconData? icon;
  final String titleKey;
  final String? subtitle;
  final Widget? content;

  const AppAlertDialog({
    super.key,
    this.confirmText = 'Ok',
    this.icon,
    required this.titleKey,
    this.subtitle,
    required this.onConfirm,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      actionsPadding: const EdgeInsets.all(10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, color: Colors.amber, size: 50),
          Text(
            titleKey,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(subtitle!),
            ),
          if (content != null) content!,
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: onConfirm,
          child: Text(
            confirmText,
          ),
        ),
      ],
    );
  }
}

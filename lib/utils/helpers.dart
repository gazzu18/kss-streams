import 'package:flutter/material.dart';

void showSnackbar({required String title, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(title),
      duration: const Duration(seconds: 1),
    ),
  );
}

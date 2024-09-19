import 'package:flutter/material.dart';

void mostrarSnackbar({
  required BuildContext context,
  required String texto,
  bool isErro = true,
}) {
  SnackBar snackbar = SnackBar(
    content: Text(texto),
    backgroundColor: isErro ? Colors.red : Colors.green,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top:  Radius.circular(16))),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

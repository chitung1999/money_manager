import 'dart:async';

import 'package:flutter/material.dart';

OverlayEntry? _overlayEntry;
Timer? _timer;

void showNotify(BuildContext context, bool status, String msg) {
  _overlayEntry?.remove();
  _timer?.cancel();

  _overlayEntry = OverlayEntry(builder: (context) => Positioned(
    bottom: 60.0,
    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: status ? Colors.green[400] : Colors.red[400],
      child: Row(
        children: [
          Icon(status ? Icons.done : Icons.error_outline, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    status ? 'SUCCESS' : 'ERROR',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, decoration: TextDecoration.none)
                ),
                const SizedBox(height: 5),
                Text(
                  msg,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal, decoration: TextDecoration.none),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ));

  Overlay.of(context).insert(_overlayEntry!);

  _timer = Timer(const Duration(seconds: 5), () {
    _overlayEntry?.remove();
    _overlayEntry = null;
  });
}
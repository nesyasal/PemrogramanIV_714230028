// lib/models/contact.dart

import 'package:flutter/material.dart';

class Contact {
  final String id;
  final String phoneNumber;
  final String name;
  final DateTime date;
  final Color color;
  final String? filePath; // Path/nama file yang di-pick

  Contact({
    required this.id,
    required this.phoneNumber,
    required this.name,
    required this.date,
    required this.color,
    this.filePath,
  });

  // Metode untuk membuat salinan data (Berguna untuk Update)
  Contact copyWith({
    String? phoneNumber,
    String? name,
    DateTime? date,
    Color? color,
    String? filePath,
  }) {
    return Contact(
      id: id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      date: date ?? this.date,
      color: color ?? this.color,
      filePath: filePath ?? this.filePath,
    );
  }
}

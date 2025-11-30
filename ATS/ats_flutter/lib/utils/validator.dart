// lib/utils/validator.dart

class FormValidator {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama wajib diisi.';
    }

    final words = value.trim().split(RegExp(r'\s+'));
    if (words.length < 2) {
      return 'Nama harus terdiri dari minimal 2 kata.'; // Minimal 2 kata
    }

    // Tidak boleh mengandung angka atau karakter khusus
    final nonAlphaNumeric = RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]');
    if (nonAlphaNumeric.hasMatch(value)) {
      return 'Nama tidak boleh mengandung angka atau karakter khusus.';
    }

    // Setiap kata harus dimulai dengan huruf kapital
    for (var word in words) {
      if (word.isEmpty) continue;
      if (word[0] != word[0].toUpperCase()) {
        return 'Setiap kata harus dimulai dengan huruf kapital.';
      }
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon wajib diisi.';
    }

    // Hanya angka
    final isNumeric = RegExp(r'^\d+$');
    if (!isNumeric.hasMatch(value)) {
      return 'Nomor telepon harus terdiri dari angka saja.';
    }

    // Panjang 8–13 digit
    if (value.length < 8 || value.length > 13) {
      return 'Panjang nomor telepon harus minimal 8 dan maksimal 13 digit.';
    }

    // Harus dimulai dengan 62
    if (!value.startsWith('62')) {
      return 'Nomor telepon harus dimulai dengan angka 62.';
    }

    return null;
  }

  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal wajib diisi.';
    }
    return null;
  }
}

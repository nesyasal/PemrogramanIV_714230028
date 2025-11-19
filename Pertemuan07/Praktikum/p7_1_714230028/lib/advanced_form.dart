// Import packages yang dibutuhkan
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk Date Picker
import 'package:file_picker/file_picker.dart'; // Untuk File Picker
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Untuk Color Picker
import 'package:open_file/open_file.dart'; // Untuk membuka file
import 'dart:io'; // Import untuk File

class AdvancedForm extends StatefulWidget {
  const AdvancedForm({super.key});

  @override
  State<AdvancedForm> createState() => _AdvancedFormState();
}

class _AdvancedFormState extends State<AdvancedForm> {
  // Variabel untuk Date Picker
  DateTime _dueDate =
      DateTime.now(); // Tanggal yang dipilih (dapat berubah) [cite: 59, 60]
  final DateTime currentDate =
      DateTime.now(); // Tanggal saat ini (konstan) [cite: 61, 63]

  // Variabel untuk Color Picker
  Color _currentColor = Colors.orange; // Warna yang dipilih [cite: 245]

  // Variabel untuk File Picker
  String? _dataFile; // Nama file yang dipilih [cite: 442, 573]
  File? _imageFile; // Objek File untuk gambar yang dipilih [cite: 574]

  // --- Date Picker Widget ---
  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Mengatur children ke kiri [cite: 68]
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, // Mengatur jarak antara children [cite: 70]
          children: [
            const Text('Date'), // Label 'Date' [cite: 72]
            TextButton(
              onPressed: () async {
                // Fungsi showDatePicker untuk menampilkan dialog pemilihan tanggal [cite: 153, 155]
                final DateTime? selectDate = await showDatePicker(
                  context: context,
                  initialDate:
                      currentDate, // Tanggal awal yang ditampilkan [cite: 159]
                  firstDate: DateTime(
                    1990,
                  ), // Batas tanggal paling awal [cite: 160]
                  lastDate: DateTime(
                    currentDate.year + 5,
                  ), // Batas tanggal paling akhir (+5 tahun dari sekarang) [cite: 161, 654]
                );

                // Memanggil setState untuk memperbarui UI jika tanggal dipilih [cite: 163, 164]
                if (selectDate != null) {
                  setState(() {
                    _dueDate =
                        selectDate; // Memperbarui variabel _dueDate [cite: 165, 166]
                  });
                }
              },
              child: const Text('Select'), // Tombol 'Select' [cite: 74]
            ),
          ],
        ),
        // Menampilkan tanggal yang sudah dipilih dengan format 'dd-MM-yyyy' [cite: 79]
        Text(DateFormat('dd-MM-yyyy').format(_dueDate)),
      ],
    );
  }

  // --- Color Picker Widget ---
  Widget _buildColorPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color'), // Label 'Color' [cite: 253]
        const SizedBox(height: 10),
        // Container yang warnanya akan berubah sesuai _currentColor [cite: 255]
        Container(
          height: 100,
          width: double.infinity,
          color: _currentColor, // Warna dari variabel _currentColor [cite: 267]
        ),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            // Warna tombol dari _currentColor [cite: 279]
            style: ElevatedButton.styleFrom(backgroundColor: _currentColor),
            onPressed: () {
              // Menampilkan dialog untuk Color Picker [cite: 324, 327]
              showDialog(
                context: context,
                builder: (context) {
                  // Variabel sementara untuk menampung warna sebelum disimpan
                  Color tempColor = _currentColor;
                  return AlertDialog(
                    title: const Text(
                      'Pick Your Color',
                    ), // Judul dialog [cite: 332]
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Menggunakan BlockPicker dari package flutter_colorpicker [cite: 360]
                        BlockPicker(
                          pickerColor:
                              _currentColor, // Warna awal picker [cite: 361]
                          onColorChanged: (color) {
                            // Memperbarui variabel sementara saat warna berubah
                            tempColor = color;
                            // Tidak memanggil setState di sini untuk mencegah dialog tertutup [cite: 364]
                          },
                        ), // BlockPicker
                      ],
                    ), // Column
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Menggunakan Navigator.of(context).pop() untuk menutup dialog [cite: 338]
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                        ), // Tombol 'Cancel' (Contoh penambahan)
                      ),
                      TextButton(
                        onPressed: () {
                          // Memanggil setState untuk memperbarui _currentColor di luar dialog
                          setState(() {
                            _currentColor =
                                tempColor; // Memperbarui warna utama [cite: 365, 366]
                          });
                          Navigator.of(
                            context,
                          ).pop(); // Menutup dialog [cite: 338]
                        },
                        child: const Text('Save'), // Tombol 'Save' [cite: 339]
                      ),
                    ], // actions
                  ); // AlertDialog
                }, // builder
              ); // showDialog
            },
            child: const Text('Pick Color'), // Tombol 'Pick Color' [cite: 285]
          ), // ElevatedButton
        ), // Center
      ],
    ); // Column
  }

  // --- File Picker Helper Methods ---
  // Fungsi untuk membuka file yang dipilih [cite: 493, 494]
  void _openFile(PlatformFile file) {
    OpenFile.open(file.path); // Menggunakan package open_file [cite: 496]
  }

  // Fungsi untuk memilih file dari storage [cite: 476, 477, 510]
  void _pickFile() async {
    final result = await FilePicker.platform
        .pickFiles(); // Memilih file [cite: 479, 511]

    if (result == null)
      return; // Jika tidak ada file yang dipilih, keluar [cite: 480, 512]

    // Mendapatkan file pertama dari objek result [cite: 504, 514]
    final file = result.files.first;

    // Mengecek apakah file yang dipilih adalah gambar [cite: 608]
    if (file.extension == 'jpg' ||
        file.extension == 'png' ||
        file.extension == 'jpeg') {
      setState(() {
        _imageFile = File(file.path!); // Mengambil file gambar [cite: 616]
      });
    }

    // Memanggil setState untuk memperbarui tampilan UI [cite: 515]
    setState(() {
      // Memperbarui nilai _dataFile dengan nama file yang dipilih [cite: 516, 517, 620, 621]
      _dataFile = file.name;
    });

    _openFile(
      file,
    ); // Memanggil fungsi untuk membuka file [cite: 505, 518, 622]
  }

  // --- File Picker Widget ---
  Widget _buildFilePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pick File'), // Label 'Pick File' [cite: 447]
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: () {
              _pickFile(); // Memanggil fungsi untuk memilih file [cite: 488]
            },
            child: const Text(
              'Pick and Open File',
            ), // Tombol 'Pick and Open File' [cite: 489]
          ), // ElevatedButton
        ), // Center
        // Menampilkan nama file jika _dataFile tidak null [cite: 447, 591]
        if (_dataFile != null) Text('File Name: $_dataFile'),
        const SizedBox(height: 10),
        // Menampilkan gambar jika _imageFile tidak null [cite: 593, 594]
        if (_imageFile != null)
          Image.file(
            _imageFile!,
            height: 200, // Ukuran gambar [cite: 597]
            width: double.infinity,
            fit: BoxFit.cover, // Menyesuaikan gambar [cite: 599]
          ), // Image.file
      ],
    ); // Column
  }

  // --- Build Method Utama ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Widget'),
        centerTitle: true,
      ), // AppBar
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Memanggil Date Picker [cite: 96, 463]
            _buildDatePicker(context),
            const SizedBox(height: 20), // Jarak antar widget [cite: 308, 464]
            // Memanggil Color Picker [cite: 309, 465]
            _buildColorPicker(context),
            const SizedBox(height: 20), // Jarak antar widget [cite: 466]
            // Memanggil File Picker [cite: 467]
            _buildFilePicker(context),
          ],
        ), // ListView
      ), // Container
    ); // Scaffold
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:file_picker/file_picker.dart';
import 'package:ats_flutter/main.dart';
import 'package:ats_flutter/models/contact.dart';
import 'package:ats_flutter/utils/validator.dart';

import 'dart:io';

class ContactListScreen extends ConsumerStatefulWidget {
  const ContactListScreen({super.key});

  @override
  ConsumerState<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends ConsumerState<ContactListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();

  Contact? _editingContact; // Menyimpan kontak yang sedang di-edit
  Color _selectedColor = Colors.green;
  String? _selectedFilePath;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // --- Fungsi Picker ---

  // Date Picker
  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  // File Picker LOGIC (sudah dijamin berjalan jika konfigurasi Gradle/SDK benar)
  Future<void> _pickFile() async {
    // Menggunakan FileType.image karena diminta untuk foto profil contact
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        // Menyimpan nama file (atau path/nama sesuai kebutuhan)
        // Gunakan result.files.first.name jika Anda hanya perlu nama
        // Gunakan result.files.first.path jika Anda perlu path lengkap
        _selectedFilePath = result.files.first.name;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File Terpilih: ${result.files.first.name}')),
        );
      }
    } else {
      // User membatalkan pemilihan
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pemilihan file dibatalkan')),
        );
      }
    }
  }

  // Color Picker Sederhana (Custom)
  Widget _buildSimpleColorPicker() {
    final List<Color> predefinedColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];

    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: predefinedColors.map((color) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedColor = color;
            });
            // Tutup dialog setelah memilih warna
            Navigator.of(context).pop();
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: _selectedColor == color
                    ? Colors.black
                    : Colors.transparent,
                width: 3,
              ),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 3),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- Fungsi CRUD ---

  void _submitForm() {
    // Validasi Semua Form
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      _formKey.currentState!.save();

      // Cek apakah ada data lain yang belum diisi (Color sudah punya default)
      if (_nameController.text.isEmpty ||
          _phoneController.text.isEmpty ||
          _dateController.text.isEmpty) {
        _showValidationSnackbar();
        return;
      }

      if (_editingContact == null) {
        // CREATE: Tambah Kontak Baru
        final newContact = Contact(
          id: const Uuid().v4(),
          name: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          date: _selectedDate!,
          color: _selectedColor,
          filePath: _selectedFilePath,
        );
        ref.read(contactListProvider.notifier).addContact(newContact);
      } else {
        // UPDATE: Perbarui Kontak
        final updatedContact = _editingContact!.copyWith(
          name: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          date: _selectedDate!,
          color: _selectedColor,
          filePath: _selectedFilePath,
        );
        ref.read(contactListProvider.notifier).updateContact(updatedContact);
        _editingContact = null; // Selesaikan mode edit
      }

      // Reset Form
      _resetForm();
    } else {
      // Tampilkan Snackbar jika form belum lengkap (atau tanggal belum dipilih)
      _showValidationSnackbar();
    }
  }

  void _showValidationSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Pengisian form belum lengkap atau ada data yang tidak valid!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _phoneController.clear();
    _dateController.clear();
    setState(() {
      _editingContact = null;
      _selectedDate = null;
      _selectedColor = Colors.green;
      _selectedFilePath = null;
    });
  }

  void _startEdit(Contact contact) {
    setState(() {
      _editingContact = contact;
      _nameController.text = contact.name;
      _phoneController.text = contact.phoneNumber;
      _selectedDate = contact.date;
      _dateController.text = DateFormat('dd-MM-yyyy').format(contact.date);
      _selectedColor = contact.color;
      _selectedFilePath = contact.filePath;
    });
  }

  void _deleteContact(String id) {
    ref.read(contactListProvider.notifier).deleteContact(id);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Kontak berhasil dihapus')));
  }

  // --- Widget Form ---

  Widget _buildContactForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 1. Phone Number
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            validator: FormValidator.validatePhoneNumber,
          ),
          const SizedBox(height: 16.0),

          // 2. Name
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: FormValidator.validateName,
          ),
          const SizedBox(height: 16.0),

          // 3. Date
          TextFormField(
            controller: _dateController,
            readOnly: true, // Tidak bisa diketik, hanya bisa dipilih
            decoration: InputDecoration(
              labelText: 'Date',
              prefixIcon: const Icon(Icons.calendar_today),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _pickDate,
              ),
            ),
            validator: FormValidator.validateDate,
            onTap: _pickDate,
          ),
          const SizedBox(height: 24.0),

          // 4. Color Picker
          const Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _selectedColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
              const SizedBox(width: 12.0),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Select a Color'),
                        content: _buildSimpleColorPicker(),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.color_lens),
                label: const Text('Pick Color'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),

          // 5. File Picker
          const Text(
            'Pick Files',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectedFilePath ?? 'No file selected',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _selectedFilePath != null
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              ElevatedButton(
                onPressed: _pickFile, // <--- Sudah terhubung ke _pickFile()
                child: const Text('Pick and Open File'),
              ),
            ],
          ),
          const SizedBox(height: 30.0),

          // Tombol Submit
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_editingContact != null)
                TextButton(
                  onPressed: _resetForm,
                  child: const Text('Cancel Edit'),
                ),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  backgroundColor: _editingContact != null
                      ? Colors
                            .orange // Warna berbeda untuk Update
                      : Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(_editingContact != null ? 'Update' : 'Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Widget List Kontak ---

  Widget _buildContactList(List<Contact> contacts) {
    if (contacts.isEmpty) {
      return const Center(
        child: Text(
          'No Contacts Yet. Add one above!',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                // Avatar
                CircleAvatar(
                  backgroundColor: contact.color.withOpacity(0.2),
                  foregroundColor: contact.color,
                  // Cek apakah ada filePath untuk ditampilkan
                  child:
                      contact.filePath != null && contact.filePath!.isNotEmpty
                      ? ClipOval(
                          // Gunakan Image.file untuk menampilkan gambar dari path file lokal
                          // Pastikan Anda telah mengimpor 'dart:io' jika Anda menggunakan File()
                          // Hati-hati: File() dari dart:io tidak didukung di Web.
                          child: Image.file(
                            File(
                              contact.filePath!,
                            ), // Pastikan Contact.filePath menyimpan path yang valid
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Text(
                          // Tampilkan inisial jika filePath null atau kosong
                          contact.name[0],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(width: 15),

                // Detail Kontak
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        contact.phoneNumber,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        DateFormat('dd-MM-yyyy').format(contact.date) +
                            (contact.filePath != null
                                ? ' | File: ${contact.filePath}'
                                : ''),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      // Garis Warna
                      const SizedBox(height: 8),
                      Container(
                        height: 5,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: contact.color,
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                    ],
                  ),
                ),

                // Tombol Aksi (Edit & Delete)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Edit (Update)
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.blue,
                      ),
                      onPressed: () => _startEdit(contact),
                    ),
                    // Delete
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.red,
                      ),
                      onPressed: () => _deleteContact(contact.id),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Build Method Utama ---

  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(contactListProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Form Input
          _buildContactForm(),

          const SizedBox(height: 40),
          const Divider(),

          // List Contact Title
          Text(
            'List Contact',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 15),

          // List Kontak
          _buildContactList(contacts),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

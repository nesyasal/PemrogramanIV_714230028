import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// Import ini hanya diperlukan jika Anda menggunakan File() dari dart:io
import 'dart:io';

// ====================================================================
// 1. MODEL: Contact (Dari models/contact.dart)
// ====================================================================

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


class FormValidator {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama wajib diisi.'; // [cite: 78, 83]
    }

    final words = value.trim().split(RegExp(r'\s+'));
    if (words.length < 2) {
      return 'Nama harus terdiri dari minimal 2 kata.'; // [cite: 84]
    }

    // Tidak boleh mengandung angka atau karakter khusus
    final nonAlphaNumeric = RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]');
    if (nonAlphaNumeric.hasMatch(value)) {
      return 'Nama tidak boleh mengandung angka atau karakter khusus.'; // [cite: 86]
    }

    // Setiap kata harus dimulai dengan huruf kapital
    for (var word in words) {
      if (word.isEmpty) continue;
      // Memeriksa apakah kata pertama atau kata-kata selanjutnya dimulai dengan kapital
      if (word[0] != word[0].toUpperCase()) {
        return 'Setiap kata harus dimulai dengan huruf kapital.'; // [cite: 85]
      }
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon wajib diisi.'; // [cite: 88]
    }

    // Hanya angka
    final isNumeric = RegExp(r'^\d+$');
    if (!isNumeric.hasMatch(value)) {
      return 'Nomor telepon harus terdiri dari angka saja.'; // [cite: 89]
    }

    // Panjang 8–13 digit
    if (value.length < 8 || value.length > 13) {
      return 'Panjang nomor telepon harus minimal 8 dan maksimal 13 digit.'; // [cite: 90]
    }

    // Harus dimulai dengan 62
    if (!value.startsWith('62')) {
      return 'Nomor telepon harus dimulai dengan angka 62.'; // [cite: 91]
    }

    return null;
  }

  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal wajib diisi.'; // [cite: 93]
    }
    return null;
  }
}

// Definisikan provider untuk list kontak
class ContactListNotifier extends StateNotifier<List<Contact>> {
  ContactListNotifier() : super(_initialContacts); // Data dummy awal

  static final List<Contact> _initialContacts = [
    // Data Dummy Sesuai Referensi Soal
    Contact(
      id: const Uuid().v4(),
      name: 'Lionel Messi',
      phoneNumber: '628122221122',
      date: DateTime(2024, 12, 1),
      color: Colors.pink,
      filePath: null,
    ),
    Contact(
      id: const Uuid().v4(),
      name: 'Cristiano Ronaldo',
      phoneNumber: '628122222211',
      date: DateTime(2024, 12, 1),
      color: Colors.yellow,
      filePath: null,
    ),
    Contact(
      id: const Uuid().v4(),
      name: 'Valentino Rossi',
      phoneNumber: '628122229087',
      date: DateTime(2024, 11, 28),
      color: Colors.blue,
      filePath: null,
    ),
    Contact(
      id: const Uuid().v4(),
      name: 'Uchsa Tecte',
      phoneNumber: '626122228754',
      date: DateTime(2024, 11, 29),
      color: Colors.red,
      filePath: null,
    ),
  ];

  void addContact(Contact contact) {
    state = [...state, contact];
  }

  void updateContact(Contact updatedContact) {
    state = [
      for (final contact in state)
        if (contact.id == updatedContact.id) updatedContact else contact,
    ];
  }

  void deleteContact(String id) {
    state = state.where((contact) => contact.id != id).toList();
  }
}

// Provider global
final contactListProvider =
    StateNotifierProvider<ContactListNotifier, List<Contact>>((ref) {
  return ContactListNotifier();
});

// ====================================================================
// 4. SCREENS: Contact List (Dari screens/contact_list.dart)
// ====================================================================

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

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _selectedFilePath = result.files.first.path;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File Terpilih: ${result.files.first.name}')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pemilihan file dibatalkan')),
        );
      }
    }
  }

  void _showColorPickerDialog() {
    Color _pickerColor = _selectedColor;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick Your Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _pickerColor,
              onColorChanged: (color) {
                _pickerColor = color;
              },
              paletteType: PaletteType.hsv,
              enableAlpha: true,
              showLabel: true,
              pickerAreaBorderRadius: BorderRadius.circular(5.0),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() => _selectedColor = _pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // --- Fungsi CRUD dan Validasi ---

  void _submitForm() {
    // Validasi Semua Form (termasuk tanggal)
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      _formKey.currentState!.save();

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
      _showValidationSnackbar(); // [cite: 78, 80]
    }
  }

  void _showValidationSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Pengisian form belum lengkap atau ada data yang tidak valid!', // [cite: 80, 81]
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
    ref.read(contactListProvider.notifier).deleteContact(id); // [cite: 73]
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
          // 1. Phone Number (Input type text field)
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number', // [cite: 38]
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
              labelText: 'Name', // [cite: 38]
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: FormValidator.validateName,
          ),
          const SizedBox(height: 16.0),

          // 3. Date (Input type text field dengan Date Picker)
          TextFormField(
            controller: _dateController, // [cite: 75]
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Date', // [cite: 38]
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
          const Text('Color',
              style: TextStyle(fontWeight: FontWeight.bold)), // [cite: 38]
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
                onPressed: _showColorPickerDialog,
                icon: const Icon(Icons.color_lens),
                label: const Text('Pick Color'), // [cite: 51]
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
                  // Menampilkan path atau "No file selected"
                  _selectedFilePath?.split('/').last ?? 'No file selected',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _selectedFilePath != null ? Colors.black : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              ElevatedButton(
                onPressed: _pickFile,
                child: const Text('Pick and Open File'), // [cite: 53]
              ),
            ],
          ),
          const SizedBox(height: 30.0),

          // Tombol Submit/Update
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_editingContact != null)
                TextButton(
                  onPressed: _resetForm,
                  child: const Text('Cancel Edit'),
                ),
              ElevatedButton(
                onPressed: _submitForm, // [cite: 72]
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  backgroundColor: _editingContact != null
                      ? Colors.orange // Warna berbeda untuk Update
                      : Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(_editingContact != null ? 'Update' : 'Submit'), // [cite: 55]
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'List Contact',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
        ),
        const SizedBox(height: 15),
        ListView.builder(
          shrinkWrap: true, // [cite: 70]
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
                    // Avatar/File
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: contact.color.withOpacity(0.2),
                      // Cek apakah ada filePath untuk ditampilkan (Gambar)
                      child: contact.filePath != null && contact.filePath!.isNotEmpty
                          ? ClipOval(
                              child: Image.file(
                                File(
                                    contact.filePath!), // Pastikan 'dart:io' di-import
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Text(
                              // Inisial jika tidak ada gambar
                              contact.name[0],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: contact.color),
                            ),
                    ),
                    const SizedBox(width: 15),

                    // Detail Kontak (Nama, Telp, Tanggal, File)
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
                                    ? ' | File: ${contact.filePath!.split('/').last}'
                                    : ''),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          // Garis Warna [cite: 70]
                          const SizedBox(height: 8),
                          Container(
                            height: 5,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: contact.color, // [cite: 70]
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
                        // Edit (Update) [cite: 74]
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.blue,
                          ),
                          onPressed: () => _startEdit(contact),
                        ),
                        // Delete [cite: 73]
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
        ),
      ],
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

          // List Kontak
          _buildContactList(contacts),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Informasi sesuai permintaan soal
    const String developerName = 'Nesya Salma Ramadhani'; // Contoh Nama
    const String developerNPM = '714230028'; // Contoh NPM

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- 1. LOGO & HEADER ---
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  // Logo/Gambar ULBI
                  Image.asset(
                    'images/ulbi.jpg', // Ganti dengan path aset yang benar
                    height: 80,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.apartment,
                        size: 80,
                        color: Theme.of(context).primaryColor,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'ULBI',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6600),
                    ),
                  ),
                  const Text(
                    'Universitas Logistik & Bisnis Internasional',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 30, thickness: 1),

            // --- 2. SELAMAT DATANG & DESKRIPSI ---
            Text(
              'Selamat Datang di Aplikasi UTS Pemrograman IV',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Ini adalah halaman Home, Anda dibebaskan untuk berkreasi untuk merombak layout yang Anda inginkan (bisa mengikuti modul layout). Semakin menarik, nilai semakin besar.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 30),

            // --- 3. INFORMASI PRIBADI (NPM & NAMA) ---
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi Developer',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    const Divider(color: Colors.black12),
                    _buildInfoRow(
                        context, 'Nama:', developerName, Icons.person_2),
                    _buildInfoRow(
                        context, 'NPM:', developerNPM, Icons.credit_card),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTS Pemrograman IV',
      theme: ThemeData(
        // Tema warna
        primarySwatch: Colors.cyan,
        primaryColor: const Color(0xFF00C7C7), // Biru/Cyan ULBI
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.cyan,
          accentColor: const Color(0xFFFF6600), // Oranye ULBI
        ).copyWith(secondary: const Color(0xFFFF6600)),
        // Menggunakan Google Fonts untuk tampilan menarik
        // (Pastikan google_fonts di pubspec.yaml)
        // textTheme: GoogleFonts.montserratTextTheme(textTheme),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

// --- Wrapper untuk Bottom Nav Bar ---

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(), // Home Screen [cite: 30]
    const ContactListScreen(), // Contact List Screen [cite: 30]
  ];

  final List<String> _screenTitles = [
    'UTS',
    'List Contacts', // [cite: 69]
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _screenTitles[_selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'), // [cite: 64]
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Contact List', // [cite: 65, 67]
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
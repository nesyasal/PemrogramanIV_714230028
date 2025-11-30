// lib/main.dart

import 'package:ats_flutter/screens/contact_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ats_flutter/screens/home_screen.dart';
import 'package:ats_flutter/models/contact.dart'; 
import 'package:uuid/uuid.dart';

// --- Riverpod State Management ---

// Definisikan provider untuk list kontak
class ContactListNotifier extends StateNotifier<List<Contact>> {
  ContactListNotifier() : super(_initialContacts); // Data dummy awal

  static final List<Contact> _initialContacts = [
    // Contoh data dummy seperti di soal
    Contact(
      id: const Uuid().v4(),
      name: 'Lionel Messi',
      phoneNumber: '628122221122',
      date: DateTime(2024, 12, 1),
      color: Colors.pink,
      filePath: 'foto_messi.jpg',
    ),
    Contact(
      id: const Uuid().v4(),
      name: 'Cristiano Ronaldo',
      phoneNumber: '628122222211',
      date: DateTime(2024, 12, 1),
      color: Colors.yellow,
      filePath: 'foto_ronaldo.jpg',
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

// --- Main App Setup ---

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Terapkan font Poppins atau Montserrat untuk tampilan yang menarik
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTS Pemrograman IV',
      theme: ThemeData(
        // Tema warna biru cerah dan oranye (seperti logo ULBI)
        primarySwatch: Colors.cyan,
        primaryColor: const Color(0xFF00C7C7), // Biru/Cyan ULBI
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.cyan,
          accentColor: const Color(0xFFFF6600), // Oranye ULBI
        ).copyWith(
          secondary: const Color(0xFFFF6600),
        ),
        // Menggunakan Google Fonts untuk tampilan menarik
        textTheme: GoogleFonts.montserratTextTheme(textTheme),
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
    const HomeScreen(), // Harus Anda buat di file home_screen.dart
    const ContactListScreen(),
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
          'UTS',
          style: GoogleFonts.poppins(
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Contact List',
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

// --- Halaman Home (Sederhana) ---
// (Anda perlu membuat file terpisah untuk ini: lib/screens/home_screen.dart)

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ganti dengan aset gambar logo ULBI Anda
            const Icon(Icons.local_shipping,
                size: 80, color: Color(0xFFFF6600)),
            Text(
              'ULBI',
              style: GoogleFonts.poppins(
                  fontSize: 50, fontWeight: FontWeight.w900, color: Theme.of(context).primaryColor),
            ),
            const Text(
              'Universitas Logistik & Bisnis Internasional',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Divider(height: 40),
            Text(
              'Selamat Datang di ULBI',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ini adalah Home, Anda bebas berkreasi. Semakin menarik tampilan, semakin besar nilai tambahan!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 30),
            // Tambahkan NPM dan Nama Anda di sini
            Text(
              'NPM: 3A-D4-Teknik Informatika',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Nama: [NAMA ANDA]',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
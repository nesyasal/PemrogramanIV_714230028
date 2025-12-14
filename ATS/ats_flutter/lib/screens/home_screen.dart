// screens/home_screen.dart

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Informasi yang bisa diganti dengan NPM dan Nama Anda
    const String developerName = 'Nesya Salma Ramadhani';
    const String developerNPM = '714230028';

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- 1. LOGO & HEADER ---
            // Bagian ini meniru tampilan di halaman 2 soal asesmen [cite: 34, 35]
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  // Asumsi logo ULBI adalah aset lokal (ulbi.png atau ulbi.jpg)
                  Image.asset(
                    'images/ulbi.jpg', // Ganti dengan path aset yang benar
                    height: 80,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback jika gambar tidak ditemukan
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
                      color: Color(0xFFFF6600), // Oranye ULBI
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
              'Selamat Datang di ULBI', 
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ini adalah halaman Home. Anda bebas berkreasi untuk membuat layout yang Anda inginkan.', 
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
                      'Detail Developer',
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
                    _buildInfoRow(
                        context, 'Kelas:', '3A-D4 Teknik Informatika', Icons.school),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 50),
            
            // Tombol untuk navigasi cepat (Opsional, karena sudah ada BottomNav)
            ElevatedButton.icon(
              onPressed: () {
                // Asumsi MainScreen memiliki metode untuk berpindah ke ContactListScreen
                // Untuk sekarang, kita hanya menampilkan snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Silakan gunakan Bottom Navigation Bar untuk ke Contact List.')),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Lihat Contact List'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk baris informasi
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
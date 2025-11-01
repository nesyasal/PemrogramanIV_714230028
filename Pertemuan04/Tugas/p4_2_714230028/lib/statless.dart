import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Menghilangkan banner "DEBUG"
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // Bagian header aplikasi
        appBar: AppBar(
          title: const Text('Tugas Pertemuan 4'),
          backgroundColor: Colors.orange, // Sesuai warna di gambar
        ),
        // Bagian utama aplikasi
        body: Center(
          // Widget utama untuk menampung semua box
          child: Column(
            // Menengahkan semua box secara vertikal di dalam Center
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // BOX 1 (Biru)
              Container(
                width: 300,
                height: 100,
                color: Colors.blue,
                // Menengahkan teks di dalam container
                alignment: Alignment.center,
                child: const Text(
                  'Box 1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Memberi jarak antara Box 1 dan Row di bawahnya
              const SizedBox(height: 20),

              // Widget untuk menampung Box 2 dan Box 3 secara horizontal
              Row(
                // Menengahkan Box 2 dan Box 3 secara horizontal
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // BOX 2 (Merah)
                  Container(
                    width: 140,
                    height: 150,
                    color: Colors.red,
                    alignment: Alignment.center,
                    child: const Text(
                      'Box 2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Memberi jarak antara Box 2 dan Box 3
                  const SizedBox(width: 20),

                  // BOX 3 (Hijau)
                  Container(
                    width: 140,
                    height: 150,
                    color: Colors.green,
                    alignment: Alignment.center,
                    child: const Text(
                      'Box 3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

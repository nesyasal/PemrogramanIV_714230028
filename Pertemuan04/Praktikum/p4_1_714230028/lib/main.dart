import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DetailScreen(),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bagian Judul
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              child: const Text(
                'Ranca Upas Ciwidey',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Bagian Informasi (Row)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  // Hari Buka
                  Column(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue),
                      SizedBox(height: 8.0),
                      Text('Setiap Hari'),
                    ],
                  ),
                  // Jam Operasional
                  Column(
                    children: [
                      Icon(Icons.access_time, color: Colors.blue),
                      SizedBox(height: 8.0),
                      Text('07.00 - 17.00'),
                    ],
                  ),
                  // Harga Tiket
                  Column(
                    children: [
                      Icon(Icons.monetization_on, color: Colors.blue),
                      SizedBox(height: 8.0),
                      Text('Rp 20.000'),
                    ],
                  ),
                ],
              ),
            ),

            // Bagian Deskripsi
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Ranca Upas Ciwidey adalah kawasan bumi perkemahan di bawah '
                'pengelolaan Perhutani. Tempat ini berada di kawasan wisata '
                'Bandung Selatan, satu lokasi dengan Kawah Putih, kolam Cimanggu, '
                'dan Situ Patenggang. Banyak hal yang bisa dilakukan di kawasan wisata ini, '
                'seperti berkemah, berinteraksi dengan rusa, sampai bermain di water park '
                'dan mandi air panas.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
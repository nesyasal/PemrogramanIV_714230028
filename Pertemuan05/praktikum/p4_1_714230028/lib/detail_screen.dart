import 'package:flutter/material.dart';
import 'model/tourism_place.dart'; 

var iniFontCustom = const TextStyle(fontFamily: 'Staatliches');

class DetailScreen extends StatelessWidget {
  
  final TourismPlace place;

  const DetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            Stack(
              children: <Widget>[
                Image.asset(
                  place.imageAsset,
                ), 
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Container(
              margin: const EdgeInsets.only(top: 16.0),
              child: Text(
                place.name, 
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30.0,
                  fontFamily:
                      'Staatliches', 
                ),
              ),
            ),

            // Bagian Informasi (Row) (Langkah 14 & 27)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              // Hapus 'const' dari Row (Langkah 14)
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Hari Buka
                  Column(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.blue),
                      const SizedBox(height: 8.0),
                      Text(
                        place.openDays, // Gunakan data dari 'place'
                        style:
                            iniFontCustom, // Terapkan font custom (Langkah 14)
                      ),
                    ],
                  ),
                  // Jam Operasional
                  Column(
                    children: [
                      const Icon(Icons.access_time, color: Colors.blue),
                      const SizedBox(height: 8.0),
                      Text(
                        place.openTime, // Gunakan data dari 'place'
                        style:
                            iniFontCustom, // Terapkan font custom (Langkah 14)
                      ),
                    ],
                  ),
                  // Harga Tiket
                  Column(
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.blue),
                      const SizedBox(height: 8.0),
                      Text(
                        place.ticketPrice, // Gunakan data dari 'place'
                        style:
                            iniFontCustom, // Terapkan font custom (Langkah 14)
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bagian Deskripsi (Langkah 27)
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                place.description, // Gunakan data dari 'place'
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),

            // Galeri Gambar Horizontal (Langkah 8, 9, 10, 11, 28)
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal, // (Langkah 9)
                // Gunakan data list 'imageUrls' dari 'place' (Langkah 28)
                children: place.imageUrls.map((url) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0), // (Langkah 10)
                    child: ClipRRect(
                      // (Langkah 11)
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(url),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

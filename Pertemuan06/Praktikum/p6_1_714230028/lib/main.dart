import 'package:flutter/material.dart';
import 'package:p6_1_714230028/bottom_navbar.dart'; // Pastikan path ini benar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Tema dasar untuk tampilan elegan
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: false, // Mempertahankan setting lama Anda
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
        ),
      ),
      home: const DynamicBottomNavbar(),
    );
  }
}

class MyInput extends StatefulWidget {
  const MyInput({super.key});

  @override
  State<MyInput> createState() => _MyInputState();
}

class _MyInputState extends State<MyInput> {
  final TextEditingController _controller = TextEditingController();
  bool lightOn = false;
  String? language;
  bool agree = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ✅ Fungsi Snackbar dengan parameter context & message
  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  // --- WIDGET INFORMASI DEVELOPER (BARU) ---
  Widget _buildDeveloperInfo(BuildContext context) {
    const String developerName =
        '714230028 | Ahmad Muzani'; // Ganti dengan Nama & NPM Anda

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.code, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Developer: $developerName',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Widget'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ELEGANT (BARU) ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Input & Controls',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Explore various interactive UI elements.',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const Divider(height: 30, thickness: 1.5),
                ],
              ),
            ),
            // --- KONTEN UTAMA (Input dan Kontrol) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. TEXT FIELD
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Write your name here...',
                      labelText: 'Your Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 2. SUBMIT BUTTON
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Submit Name'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Submitted'),
                            content: Text('Hello, ${_controller.text}!'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'SWITCH CONTROL',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  // 3. SWITCH
                  SwitchListTile(
                    title: const Text('Light On/Off'),
                    subtitle: Text(lightOn ? 'Current: ON' : 'Current: OFF'),
                    value: lightOn,
                    onChanged: (bool value) {
                      setState(() {
                        lightOn = value;
                      });
                      showSnackbar(context, lightOn ? 'Light On' : 'Light Off');
                    },
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'RADIO BUTTONS (Language)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  // 4. RADIO BUTTONS
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<String>(
                        title: const Text('Dart'),
                        value: 'Dart',
                        groupValue: language,
                        onChanged: (String? value) {
                          setState(() {
                            language = value;
                            showSnackbar(context, 'You selected $language');
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Kotlin'),
                        value: 'Kotlin',
                        groupValue: language,
                        onChanged: (String? value) {
                          setState(() {
                            language = value;
                            showSnackbar(context, 'You selected $language');
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Swift'),
                        value: 'Swift',
                        groupValue: language,
                        onChanged: (String? value) {
                          setState(() {
                            language = value;
                            showSnackbar(context, 'You selected $language');
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // 5. CHECKBOX
                  CheckboxListTile(
                    title: const Text('I agree with the terms and conditions'),
                    value: agree,
                    onChanged: (bool? value) {
                      setState(() {
                        agree = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            // --- FOOTER DEVELOPER INFO (BARU) ---
            _buildDeveloperInfo(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

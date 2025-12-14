import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late SharedPreferences loginData;
  String username = "";

  void initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      username = loginData.getString('username').toString();
    });
  }

  @override
  void initState() {
    super.initState();
    initial();
  }

  // FUNGSI LOGOUT (Ketentuan 3 & 4)
  void doLogout() async {
    loginData =
        await SharedPreferences.getInstance(); 
    loginData.setBool('login', true);

    // LOGIKA REMEMBER ME:
    bool rememberMeActive = (loginData.getBool('rememberMe') ?? false);

    // Hapus username HANYA JIKA "Remember Me" TIDAK AKTIF 
    if (!rememberMeActive) {
      loginData.remove('username');
      // Jika Remember Me aktif, username tetap tersimpan 
    }
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            children: [
              const Text('Welcome to Home'),
              const SizedBox(height: 20),
              Text(username),
              ElevatedButton(onPressed: doLogout, child: const Text('Logout')),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'data_service.dart';
import 'user.dart';
import 'user_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataService _dataService = DataService();
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _jobCtl = TextEditingController();

  String _result = '-';
  List<User> _users = [];
  UserCreate? usCreate; // Untuk hasil POST
  UserUpdate? usUpdate; // Untuk hasil PUT (Tugas)

  @override
  void dispose() {
    _nameCtl.dispose();
    _jobCtl.dispose();
    super.dispose();
  }

  void displaySnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('REST API (DIO)'), elevation: 2),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Bagian Input ---
              _buildTextField(_nameCtl, 'Name'),
              const SizedBox(height: 10),
              _buildTextField(_jobCtl, 'Job'),
              const SizedBox(height: 15),

              // --- Baris Tombol Utama ---
              Row(
                children: [
                  _buildActionButton('GET', () async {
                    final res = await _dataService.getUsers();
                    if (res != null) {
                      setState(() => _result = res.toString());
                    } else {
                      displaySnackbar('Failed to get data');
                    }
                  }),
                  const SizedBox(width: 8),
                  _buildActionButton('POST', () async {
                    if (_nameCtl.text.isEmpty || _jobCtl.text.isEmpty) {
                      displaySnackbar('Semua field harus diisi');
                      return;
                    }
                    final postModel = UserCreate(
                      name: _nameCtl.text,
                      job: _jobCtl.text,
                    );
                    final res = await _dataService.postUser(postModel);
                    if (res != null) {
                      setState(() {
                        _result = res.toString();
                        usCreate = res;
                        usUpdate = null; // Hapus hasil PUT jika ada
                      });
                      _nameCtl.clear();
                      _jobCtl.clear();
                    }
                  }),
                  const SizedBox(width: 8),
                  _buildActionButton('PUT', () async {
                    if (_nameCtl.text.isEmpty || _jobCtl.text.isEmpty) {
                      displaySnackbar('Semua field harus diisi');
                      return;
                    }
                    
                    final res = await _dataService.putUser(
                      '3',
                      _nameCtl.text,
                      _jobCtl.text,
                    );
                    if (res != null) {
                      setState(() {
                        _result = res.toString();
                        usUpdate = res; // Simpan hasil PUT
                        usCreate = null; // Hapus hasil POST jika ada
                      });
                      _nameCtl.clear();
                      _jobCtl.clear();
                    }
                  }),
                  const SizedBox(width: 8),
                  _buildActionButton('DELETE', () async {
                    final res = await _dataService.deleteUser('4');
                    setState(() => _result = res.toString());
                  }),
                ],
              ),
              const SizedBox(height: 10),

              // --- Baris Tombol Tambahan ---
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final users = await _dataService.getUserModel();
                        setState(() {
                          _users = users?.toList() ?? [];
                        });
                      },
                      child: const Text('Model Class User Example'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[50],
                    ),
                    onPressed: () {
                      setState(() {
                        _result = '-';
                        _users.clear();
                        usCreate = null; // Reset hasil POST
                        usUpdate = null; // Reset hasil PUT
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                'Result',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Divider(),

              // --- Tampilan Hasil ---
              SizedBox(
                width: double.infinity,
                child: _users.isEmpty
                    ? Text(_result)
                    : Container(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: _buildListUser(),
                      ),
              ),

              const SizedBox(height: 20),
              
              // --- Tampilkan Kartu Hasil POST atau PUT ---
              _buildHasilCard(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        suffixIcon: IconButton(
          onPressed: controller.clear,
          icon: const Icon(Icons.clear),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 11)),
      ),
    );
  }

  Widget _buildListUser() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: _users.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final user = _users[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(user.avatar)),
            title: Text('${user.firstName} ${user.lastName}'),
            subtitle: Text(user.email),
          ),
        );
      },
    );
  }

  Widget _buildHasilCard() {
    return Center(
      child: Column(
        children: [
          if (usCreate != null) UserCard(usrCreate: usCreate!),
          if (usUpdate != null) PutCard(usrUpdate: usUpdate!), // Kartu PUT
          if (usCreate == null && usUpdate == null) const Text('no data'),
        ],
      ),
    );
  }
}
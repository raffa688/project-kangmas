import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final _passConfCtl = TextEditingController();

  // Tukang specific
  final _addressCtl = TextEditingController();
  final _priceCtl = TextEditingController();
  
  String _role = 'user';
  String _category = 'listrik';

  Future<void> _register() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    Map<String, dynamic> data = {
      'name': _nameCtl.text,
      'email': _emailCtl.text.trim(),
      'password': _passCtl.text,
      'password_confirmation': _passConfCtl.text,
      'role': _role,
      'phone_number': _phoneCtl.text,
    };

    if (_role == 'tukang') {
      data['category'] = _category;
      data['address'] = _addressCtl.text;
      data['base_price'] = int.tryParse(_priceCtl.text) ?? 50000;
      // Mock latitude/longitude near Telkom Univ for MVP
      data['latitude'] = -6.9730;
      data['longitude'] = 107.6307;
    }

    try {
      final success = await auth.register(data);
      if (success) {
        if (auth.user?.role == 'tukang') {
          Navigator.pushNamedAndRemoveUntil(context, '/tukang_home', (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/user_home', (route) => false);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Daftar Akun', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Buat Akun Baru',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Lengkapi data di bawah untuk bergabung dengan KANGMAS',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 30),
            
            // Role Selector with custom styling
            const Text('Mendaftar sebagai:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('User')),
                    selected: _role == 'user',
                    onSelected: (val) => setState(() => _role = 'user'),
                    selectedColor: Colors.amber.shade700,
                    labelStyle: TextStyle(color: _role == 'user' ? Colors.white : Colors.black),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Tukang')),
                    selected: _role == 'tukang',
                    onSelected: (val) => setState(() => _role = 'tukang'),
                    selectedColor: Colors.amber.shade700,
                    labelStyle: TextStyle(color: _role == 'tukang' ? Colors.white : Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildTextField(_nameCtl, 'Nama Lengkap', Icons.person_outline),
            const SizedBox(height: 16),
            _buildTextField(_emailCtl, 'Email', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildTextField(_phoneCtl, 'No. WhatsApp', Icons.phone_android_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField(_passCtl, 'Password', Icons.lock_outline, obscureText: true),
            const SizedBox(height: 16),
            _buildTextField(_passConfCtl, 'Konfirmasi Password', Icons.lock_reset_outlined, obscureText: true),
            
            if (_role == 'tukang') ...[
              const SizedBox(height: 32),
              const Text('Profil Profesional Tukang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(
                  labelText: 'Kategori Keahlian',
                  prefixIcon: const Icon(Icons.build_circle_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: 'listrik', child: Text('Listrik')),
                  DropdownMenuItem(value: 'air', child: Text('Air / Plumbing')),
                  DropdownMenuItem(value: 'bangunan', child: Text('Bangunan')),
                ],
                onChanged: (val) => setState(() => _category = val!),
              ),
              const SizedBox(height: 16),
              _buildTextField(_addressCtl, 'Alamat Tinggal', Icons.location_on_outlined),
              const SizedBox(height: 16),
              _buildTextField(_priceCtl, 'Harga Dasar Jasa (Rp)', Icons.payments_outlined, keyboardType: TextInputType.number),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text('Note: Lokasi akan di-set otomatis untuk demo.', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ],

            const SizedBox(height: 40),
            
            if (auth.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: _register,
                child: const Text('DAFTAR SEKARANG', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}

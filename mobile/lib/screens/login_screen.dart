import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtl = TextEditingController();
  final _passwordCtl = TextEditingController();

  Future<void> _launchRegisterUrl() async {
    // Gunakan IP Laptop Anda
    final Uri url = Uri.parse('http://10.60.13.88:8000/register');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _login() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    try {
      final success = await auth.login(_emailCtl.text.trim(), _passwordCtl.text);
      if (success) {
        if (auth.user?.role == 'tukang') {
          Navigator.pushReplacementNamed(context, '/tukang_home');
        } else {
          Navigator.pushReplacementNamed(context, '/user_home');
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Yellow Background and Icon
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.amber.shade700,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.engineering, size: 80, color: Colors.amber.shade700),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'KANGMAS',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const Text(
                    'Solusi Tukang Terpercaya',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat Datang',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Silakan masuk untuk melanjutkan',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 30),

                  TextField(
                    controller: _emailCtl,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _passwordCtl,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    obscureText: true,
                  ),

                  const SizedBox(height: 40),

                  if (auth.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text('MASUK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),

                  const SizedBox(height: 20),

                  Center(
                    child: TextButton(
                      onPressed: _launchRegisterUrl,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black54),
                          children: [
                            const TextSpan(text: 'Belum punya akun? '),
                            TextSpan(
                              text: 'Daftar Sekarang',
                              style: TextStyle(color: Colors.amber.shade800, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const Center(
                    child: Text(
                      'DEVELOPER TOOLS (Bypass)',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/user_home'),
                          icon: const Icon(Icons.person_search, size: 18),
                          label: const Text('BYPASS USER', style: TextStyle(fontSize: 12)),
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/tukang_home'),
                          icon: const Icon(Icons.engineering, size: 18),
                          label: const Text('BYPASS TUKANG', style: TextStyle(fontSize: 12)),
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.orange.shade900),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

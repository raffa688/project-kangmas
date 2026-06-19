import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProofApprovalScreen extends StatefulWidget {
  const ProofApprovalScreen({super.key});

  @override
  State<ProofApprovalScreen> createState() => _ProofApprovalScreenState();
}

class _ProofApprovalScreenState extends State<ProofApprovalScreen> {
  bool _isLoading = false;

  Future<void> _approve(int orderId) async {
    setState(() => _isLoading = true);
    try {
      await ApiService.patch('/orders/$orderId/approve');
      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(context, '/user_home', (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Orderan selesai! Makasih udah pake Kangmas.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Hasil'),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Foto dari Tukang:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // nampilin foto bukti
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  '${ApiService.storageUrl}/${order['proof_image']}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50),
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              'Gimana hasilnya?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Kalau sudah sesuai, klik Selesai ya biar pembayarannya diteruskan ke tukang.'),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _approve(order['id']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Ya, Sudah Sesuai / Selesai', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

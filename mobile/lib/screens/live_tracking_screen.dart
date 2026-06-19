import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key});

  Future<void> _launchWhatsApp(BuildContext context, String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nomor telepon tidak tersedia")),
      );
      return;
    }

    // bersihin no dri karakter yg bkan angka
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // rubah awalan 0 ke 62 (kode indo) klo perlu
    if (cleanNumber.startsWith('0')) {
      cleanNumber = '62${cleanNumber.substring(1)}';
    }

    final Uri url = Uri.parse("https://wa.me/$cleanNumber");

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Tidak dapat membuka WhatsApp';
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal membuka WhatsApp: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final order = Map<String, dynamic>.from(args);
    final tukang = order['tukang'] ?? {};

    return Scaffold(
      body: Stack(
        children: [
          // bg map boongan aja
          Container(
            color: const Color(0xFFFFF9E7),
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: MapPainter(),
            ),
          ),

          // tombol buat blik
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // kartu info yg d bawah
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // profil kang mas nya
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.amber[100],
                        child: const Icon(Icons.person, size: 35, color: Colors.amber),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tukang['name'] ?? 'Tukang Kangmas',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              tukang['phone_number'] ?? 'No. Telp Tidak Ada',
                              style: const TextStyle(color: Colors.amber, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30),

                  // estimasi nyampe nya
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.amber),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Perkiraan TUKANG Sampai', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text('15 - 20 Menit', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        child: const Text('Laporkan', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // bagian lokasii
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.amber),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Lokasimu', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text(order['address'] ?? 'Alamat tidak tertera',
                                 style: const TextStyle(fontWeight: FontWeight.bold),
                                 maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                        child: IconButton(
                          icon: const Icon(Icons.call, color: Colors.white),
                          onPressed: () => _launchWhatsApp(context, tukang['phone_number']),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),

                  // tombol selesein pesenan
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/user_home', (route) => false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC107),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Selesaikan Pesanan', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 25
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(0, size.height * 0.2), Offset(size.width, size.height * 0.2), paint);
    canvas.drawLine(Offset(0, size.height * 0.5), Offset(size.width, size.height * 0.5), paint);
    canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width * 0.3, size.height), paint);
    canvas.drawLine(Offset(size.width * 0.7, 0), Offset(size.width * 0.7, size.height), paint);

    final trackPaint = Paint()
      ..color = Colors.blue.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.3, size.height * 0.7);
    path.lineTo(size.width * 0.3, size.height * 0.5);
    path.lineTo(size.width * 0.7, size.height * 0.5);
    path.lineTo(size.width * 0.7, size.height * 0.3);
    canvas.drawPath(path, trackPaint);

    final userPinPaint = Paint()..color = Colors.red;
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.3), 10, userPinPaint);

    final driverCirclePaint = Paint()..color = const Color(0xFF0F172A);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), 18, driverCirclePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

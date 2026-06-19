import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'screens/login_screen.dart';
import 'screens/user_home_screen.dart';
import 'screens/tukang_home_screen.dart';
import 'screens/job_detail_screen.dart';
import 'screens/live_tracking_screen.dart';
import 'screens/job_closing_screen.dart';
import 'screens/proof_approval_screen.dart';

void main() async {
  // Pastiin binding Flutter siap sebelum panggil fungsi async
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi API & nyari IP server secara otomatis di WiFi
  await ApiService.init();

  runApp(const KangMasApp());
}

class KangMasApp extends StatelessWidget {
  const KangMasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KangMas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/user_home': (context) => const UserHomeScreen(),
        '/tukang_home': (context) => const TukangHomeScreen(),
        '/job_detail': (context) => const JobDetailScreen(),
        '/live_tracking': (context) => const LiveTrackingScreen(),
        '/job_closing': (context) => const JobClosingScreen(),
        '/proof_approval': (context) => const ProofApprovalScreen(),
      },
    );
  }
}

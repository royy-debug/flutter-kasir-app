import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kasir_flutter_app/mobile/screens/auth_screen.dart';
import 'package:kasir_flutter_app/mobile/screens/main_screen.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Kalau ada user → ke Dashboard
        if (snapshot.hasData) {
          return const MainScreen();
        }

        // Kalau belum login → ke Auth
        return const AuthScreen();
      },
    );
  }
}

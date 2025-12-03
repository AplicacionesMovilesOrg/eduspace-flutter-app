import 'package:flutter/material.dart';
import 'package:eduspace_flutter_app/presentation/widgets/side_menu.dart'; 

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: const SideMenu(), 
        
        appBar: AppBar(
          title: const Text('EduSpace'),
          backgroundColor: const Color(0xFF4285F4), // Azul Eduspace
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            'Presiona el icono de menú (≡)\narriba a la izquierda',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
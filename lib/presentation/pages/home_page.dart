import 'package:flutter/material.dart';
import 'package:eduspace_flutter_app/presentation/widgets/side_menu.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color(0xFF4285F4), 
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Contenido de Eduspace'),
      ),
    );
  }
}
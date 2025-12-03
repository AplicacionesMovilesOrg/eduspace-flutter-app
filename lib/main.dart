import 'package:eduspace_flutter_app/core/ui/theme.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/presentation/pages/reservation_create_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final materialTheme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'EduSpace Reservations',
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.light, 
      debugShowCheckedModeBanner: false,
      home: const ReservationCreatePage(
        teacherId: "1", 
        areaId: "1",    
      ),
    );
  }
}
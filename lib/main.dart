import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/eticket_page.dart';
import 'dart:convert';

void main() {
  runApp(BusTicketApp());
}

class BusTicketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Ticket Management System',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E), // Deep Indigo
          primary: const Color(0xFF1A237E),
          secondary: const Color(0xFFFFA000), // Amber
          surface: Colors.white,
          background: const Color(0xFFF5F7FB),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
          bodyLarge: TextStyle(color: Color(0xFF2C3E50)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A237E),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A237E),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        if (settings.name != null && settings.name!.startsWith('/tix/')) {
          final uri = Uri.parse(settings.name!);
          final parts = uri.pathSegments;
          if (parts.length >= 2 && parts[0] == 'tix') {
            final bookingId = parts[1];
            String busName = 'Bus Reguler';
            String route = 'Tidak Diketahui';
            String date = 'Tidak Diketahui';
            String seats = '-';
            
            if (uri.queryParameters.containsKey('d')) {
              try {
                // Determine padding if missing
                String base64Str = uri.queryParameters['d']!;
                while (base64Str.length % 4 != 0) {
                  base64Str += '=';
                }
                final decodedJson = utf8.decode(base64Url.decode(base64Str));
                final Map<String, dynamic> data = jsonDecode(decodedJson);
                busName = data['bus'] ?? busName;
                route = data['rute'] ?? route;
                date = data['tanggal'] ?? date;
                seats = data['kursi'] ?? seats;
              } catch (e) {
                debugPrint('Ticket Decode Error: $e');
              }
            } else {
              busName = uri.queryParameters['bus'] ?? busName;
              route = uri.queryParameters['rute'] ?? route;
              date = uri.queryParameters['tanggal'] ?? date;
              seats = uri.queryParameters['kursi'] ?? seats;
            }
            
            return MaterialPageRoute(
              builder: (context) => ETicketPage(
                bookingId: bookingId,
                busName: busName,
                route: route,
                date: date,
                seats: seats,
              ),
            );
          }
        }
        return null;
      },
      home: HomePage(),
    );
  }
}
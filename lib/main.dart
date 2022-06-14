import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scanner/app_routes.dart';
import 'package:scanner/lista_cod.dart';
import 'package:scanner/qrcode_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Scanner',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.grey[900],
          //__________
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: Colors.tealAccent,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 36),
              onPrimary: Colors.black,
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          //__________________
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: Colors.tealAccent,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          //=====================
        ),
        home: const QRCodePage(),
        routes: {
          AppRoutes.LIST_COD: (ctx) => const ListCod(),
          AppRoutes.QRCODE_PAGE: (ctx) => const QRCodePage(),
        });
  }
}

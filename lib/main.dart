import 'package:coffe_app/firebase_options.dart';
import 'package:coffe_app/screens/detail/detail.dart';
import 'package:coffe_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main()async {
 WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      )
    );
    
    return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Bi Kahve',
  home: SplashScreen(),
  onGenerateRoute: (settings) {
    if (settings.name == '/detail') {
      final args = settings.arguments;
      if (args == null || args is! String || args.isEmpty) {
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Geçersiz veya eksik ID')),
          ),
        );
      }
      final foodId = args as String;
      return MaterialPageRoute(
        builder: (_) => DetailPage(foodId: foodId),
      );
    }
    return null;
  },
);

  }
}
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './authentication/app.dart';
import 'firebase_options.dart';
import './screens/onboarding_service.dart';

const clientId =
    '651783528324385-h21mv201j9mpgi2mgpvr4c78mffk5dat4l46ve.apps.googleusercontent.com';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // Transparent navigation bar
    statusBarColor: Colors.transparent, // Transparent status bar
  ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final bool isFirstLaunch = await OnboardingService.isFirstLaunch();
  runApp(MyApp(
    isFirstLaunch: isFirstLaunch,
  ));
}

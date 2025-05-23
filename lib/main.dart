import 'package:detectionapp/firebase_options.dart';
import 'package:detectionapp/screen/notipage.dart';
import 'package:detectionapp/service/firebase_messaging_service.dart';
import 'package:detectionapp/service/local_notifications_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    // bool inDebug = false;
    // assert(() {
    //   inDebug = true;
    //   return true;
    // }());
    // if (inDebug) {
    //   return ErrorWidget(details.exception);
    // }
    return Container(
      alignment: Alignment.center,
      child: Text('Error\n${details.exception}',
          style: const TextStyle(
              color: Colors.orangeAccent,
              fontWeight: FontWeight.bold,
              fontSize: 20),
          textAlign: TextAlign.center),
    );
  };

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final localNotificationsService = LocalNotificationsService.instance();
  await LocalNotificationsService.init();

  final firebaseMessagingService = FirebaseMessagingService.instance();
  await firebaseMessagingService.init(
      LocalNotificationsService: localNotificationsService);

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});
  _App createState() => _App();
}

class _App extends State<App> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Detection App',
      theme: ThemeData(
        fontFamily: 'Roboto',
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Notipage(),
    );
  }
}

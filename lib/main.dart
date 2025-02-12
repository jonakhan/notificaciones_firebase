import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Importa Firebase Messaging
import 'login_screen.dart'; // Asegúrate de importar tu pantalla de inicio de sesión
import 'package:logger/logger.dart'; // Importa el paquete logger

final Logger logger = Logger(); // Crea una instancia del logger

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Manejar el mensaje en segundo plano
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa Firebase

  // Configura el manejo de mensajes en segundo plano
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Obtén el token de FCM
  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    logger.i('FCM Token: $token'); // Registra el token
  } else {
    logger.e('No se pudo obtener el token de FCM');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Configura el manejo de mensajes en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensaje recibido: ${message.data}');
      if (message.notification != null) {
        // Aquí puedes mostrar un diálogo o una notificación local
        print('Notificación: ${message.notification!.title}');
      }
    });

    return MaterialApp(
      title: 'Flutter Firebase App',
      theme: ThemeData.dark(),
      home: LoginScreen(), // Cambia esto a tu pantalla de inicio de sesión
    );
  }
}

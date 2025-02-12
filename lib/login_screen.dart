import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Importa Firebase Messaging
import 'welcome_screen.dart';
import 'package:logger/logger.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Logger _logger = Logger();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _message = '';

  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging(); // Configura el manejo de notificaciones
  }

  void _setupFirebaseMessaging() {
    // Solicitar permisos para recibir notificaciones
    FirebaseMessaging.instance.requestPermission();

    // Escuchar mensajes en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensaje recibido: ${message.data}');
      if (message.notification != null) {
        // Mostrar un diálogo con el contenido de la notificación
        _showNotificationDialog(
            message.notification?.title, message.notification?.body);
      }
    });

    // Escuchar mensajes abiertos desde la notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Mensaje abierto: ${message.messageId}');
      // Aquí puedes navegar a una pantalla específica si es necesario
    });
  }

  void _showNotificationDialog(String? title, String? body) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title ?? 'Notificación'),
          content: Text(body ?? 'Tienes un nuevo mensaje.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _login() async {
    _logger.i("Intentando iniciar sesión...");
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _message = 'Por favor, completa todos los campos.';
      });
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _logger.i("Usuario autenticado: ${userCredential.user?.email}");

      // Navegar a la pantalla de bienvenida
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _message = 'Inicio de sesión fallido: ${e.message}';
      });
      _logger.e("Error de inicio de sesión: ${e.message}");
    }
  }

  void _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _message = 'Por favor, completa todos los campos.';
      });
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      setState(() {
        _message =
            'Usuario creado exitosamente:  ${userCredential.user?.email}. Puedes iniciar sesión ahora.';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _message = 'Registro fallido: ${e.message}';
      });
    }
  }

  void _resetPassword() async {
    final email = _emailController.text;

    if (email.isEmpty) {
      setState(() {
        _message = 'Por favor, ingresa tu correo electrónico.';
      });
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        _message = 'Se ha enviado un correo para restablecer la contraseña.';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _message = 'Error al enviar el correo: ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_OLy53eBNqQNHM VE1VEa3x2ajvOZYAK8S5A&s', // Reemplaza con tu URL de imagen
              height: 150, // Establece la altura de la imagen
              fit: BoxFit.cover, // Ajusta el ajuste de la imagen
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Iniciar Sesión'),
            ),
            ElevatedButton(
              onPressed: _register,
              child: Text('Registrar Usuario'),
            ),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Recuperar Contraseña'),
            ),
            SizedBox(height: 20),
            Text(_message, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

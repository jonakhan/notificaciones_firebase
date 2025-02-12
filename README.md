# Guía para Agregar Notificaciones Push en Flutter con Firebase

Esta guía te ayudará a integrar notificaciones push en tu aplicación Flutter utilizando Firebase Cloud Messaging (FCM).

## 1. Crear un Proyecto en Firebase

1. Accede a la [Consola de Firebase](https://console.firebase.google.com/).
2. Crea un nuevo proyecto. Esto te permitirá gestionar todos los servicios de Firebase para tu aplicación.

## 2. Agregar tu Aplicación a Firebase

1. Dentro del proyecto, agrega tu aplicación (Android o iOS).
2. Proporciona información como el nombre del paquete de tu aplicación.
3. Descarga el archivo de configuración que Firebase genera para tu aplicación:
   - Para Android: `google-services.json`
   - Para iOS: `GoogleService-Info.plist`

## 3. Colocar el Archivo de Configuración

1. Coloca el archivo de configuración en la carpeta adecuada de tu proyecto Flutter:
   - Para Android: `android/app/`
   - Para iOS: `ios/Runner/`

## 4. Agregar Dependencias en tu Proyecto Flutter

1. Abre el archivo `pubspec.yaml` de tu proyecto.
2. Agrega las siguientes dependencias:

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     firebase_core: ^latest_version
     firebase_messaging: ^latest_version

## 4. Ejecutar Dependencias

Ejecuta `flutter pub get` para instalar las dependencias.

## 5. Inicializar Firebase en tu Aplicación

En el archivo principal de tu aplicación (por ejemplo, `main.dart`), inicializa Firebase. Esto es necesario para que tu aplicación pueda interactuar con los servicios de Firebase.

## 6. Obtener el Token de FCM

Una vez que Firebase esté inicializado, tu aplicación debe solicitar y obtener un token de FCM. Este token es único para cada dispositivo y se utiliza para enviar notificaciones a ese dispositivo específico.

## 7. Configurar el Manejo de Mensajes

Configura tu aplicación para manejar mensajes de FCM. Esto incluye definir cómo tu aplicación reaccionará cuando reciba una notificación mientras está en primer plano (abierta) o en segundo plano (cerrada).

## 8. Probar las Notificaciones

Utiliza la consola de Firebase para enviar un mensaje de prueba a tu aplicación. Asegúrate de que tu aplicación esté en primer plano o en segundo plano para verificar que recibe la notificación correctamente.

## Consideraciones Finales

- **Permisos**: Asegúrate de que tu aplicación tenga los permisos necesarios para recibir notificaciones, especialmente en dispositivos iOS.
- **Pruebas**: Realiza pruebas exhaustivas para asegurarte de que las notificaciones se reciban correctamente en diferentes estados de la aplicación (abierta, en segundo plano y cerrada).
- **Documentación**: Consulta la documentación oficial de Firebase y Flutter para obtener más detalles y resolver cualquier problema que puedas encontrar.
